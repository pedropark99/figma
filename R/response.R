#' Parse the response object returned by Figma API
#'
#'

response_content <- function(response){
  httr::content(response, encoding = "UTF-8")
}


parse_response_object <- function(response, .output_format){
  check_for_http_errors(response)
  output_format <- check_output_format(.output_format)
  if (output_format == 'response') {
    return(response)
  }
  if (output_format == 'figma') {
    return(as_figma_document(response))
  }
}

check_for_http_errors <- function(response,
                                  call = rlang::caller_env()){

  if (!httr:::is.response(response)) {
    rlang::abort(
      "Object given to `response` is not of type `response`!",
      call = call
    )
  }
  if (response$status_code != 200) {
    report_http_error(response)
  }
}

report_http_error <- function(response,
                              call = rlang::caller_env(n = 3)){

  content <- response_content(response)
  header <- "HTTP Error:\n\n"
  url <- sprintf(
    "* URL used in the request: %s\n", response$url
  )
  status <- sprintf(
    "* Status code returned by the API: %s\n", response$status_code
  )
  error_message <- sprintf(
    "* Error message returned by the API: %s\n", content$err
  )
  headers <- sprintf(
    "* Headers returned by the API:\n%s\n",
    response$all_headers[[1]] |>
      utils::str() |>
      utils::capture.output() |>
      paste0(collapse = "\n")
  )

  rlang::abort(
    c(header, url, status, error_message, headers) |>
      paste0(collapse = ""),
    call = call
  )
}


check_output_format <- function(format){
  formats_allowed <- c('response', 'figma_document', 'tibble')
  if ( !(format %in% formats_allowed) ) {
    msg <- sprintf("Output format '%s' not allowed!", format)
    formats <- sprintf("'%s'", formats_allowed)
    formats <- paste0(formats, collapse = ", ")
    msg <- paste0(
      msg, "\n",
      sprintf("Choose one of the following options: %s", formats)
    )
    stop(msg)
  }
  return(format)
}

#' Convert a `httr` response object to a Figma Document object
#'
#' This function is not intended for client/user-use.
#'
#' @param response a `response` object produced by a `httr` HTTP method (e.g. `httr::GET()`, `httr::POST()`, etc.);
as_figma_document <- function(response){
  if (!inherits(response, "response")) {
    stop("Object is not of type `response`!")
  }
  content <- httr::content(a)
  document <- content$document[c("id", "name", "type")]
  canvas <- content$document[["children"]]
  n_nodes <- purrr::map_int(canvas, length)
  names(n_nodes) <- paste("Canvas", seq_along(canvas))
  structure(
    list(name = "Figma Document", document = document,
         canvas = canvas, n_canvas = length(canvas),
         n_nodes = n_nodes),
    class = "figma_document"
  )
}


#' Print method for Figma Document objects
#' @exportS3Method
print.figma_document <- function(x, ...){
  cat("<Figma Document>", "\n\n", sep = "")
  cat(" * Number of canvas:", x$n_canvas, "\n")
  cat(" * Number of nodes:", x$n_nodes, "\n")
  invisible(x)
}


as_tibble <- function(response){
  document <- as_figma_document(response)
  canvas <- document$canvas
  list_of_tibbles <- vector("list", length = length(canvas))
  for (i in seq_along(canvas)) {
    canvas_metadata <- get_canvas_metadata(canvas[[i]])
    objects_data <- parse_objects(canvas[[i]])
    objects_data$canvas_id <- canvas_metadata$id
    objects_data$canvas_name <- canvas_metadata$name
    list_of_tibbles[[i]] <- objects_data |>
      dplyr::rename(
        object_id = "id",
        object_name = "name"
      ) |>
      dplyr::select(
        dplyr::starts_with("canvas"),
        dplyr::starts_with("object")
      )
  }
  dplyr::bind_rows(list_of_tibbles)
}

standard_attrs <- c("id", "name", "type")

get_canvas_metadata <- function(canva){
  attrs <- canva[standard_attrs]
  return(attrs)
}


parse_objects <- function(canva){
  objects <- get_canva_objects(canva)
  build_objects_tibble(objects)
}


build_objects_tibble <- function(objects){
  table <- get_standard_attributes(objects)
  table$object_attributes <- get_nonstandard_attributes(objects)
  return(table)
}

get_standard_attributes <- function(objects){
  attrs <- purrr::map(objects, ~.[standard_attrs])
  attrs <- purrr::transpose(attrs)
  attrs <- map(attrs, unlist)
  return(tibble::as_tibble(attrs))
}


get_nonstandard_attributes <- function(objects){
  nonstandard_attrs <- map(objects, find_nonstandard_attr)
  attrs <- map2(objects, nonstandard_attrs, `[`)
  return(attrs)
}


get_canva_objects <- function(canva){
  canva$children
}


find_nonstandard_attr <- function(node){
  attr_names <- names(node)
  non_standard_attrs <- attr_names[
    !(attr_names %in% standard_attrs)
  ]
  return(non_standard_attrs)
}

#' Extract all canvas from a Figma Document
#'
#' Collect all canvas objects present in a Figma Document object.
#'
#' @param document a Figma Document (i.e. a object of class `figma_document`);
extract_canvas <- function(document){
  list_of_canvas <- document$content$children
}
