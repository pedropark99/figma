#' Parse the response object returned by Figma API
#'
#'
standard_attrs <- c("id", "name", "type")
document_attrs <- c(
  "name", "components", "componentSets",
  "styles", "schemaVersion", "lastModified",
  "thumbnailUrl", "version", "role",
  "editorType", "linkAccess"
)

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
  if (output_format == 'tibble') {
    return(as_tibble(response))
  }
}

check_for_http_errors <- function(response,
                                  call = rlang::caller_env()){

  if (!inherits(response, "response")) {
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
  content <- httr::content(response)
  document <- content[document_attrs]
  document <- c(content$document[c("id", "type")], document)
  canvas <- content$document[["children"]]
  n_nodes <- purrr::map_int(canvas, length)
  names(n_nodes) <- paste("Canvas", seq_along(canvas))
  structure(
    list(document = document, canvas = canvas,
         n_canvas = length(canvas), n_nodes = n_nodes),
    class = "figma_document"
  )
}


#' @exportS3Method
print.figma_document <- function(x, ...){
  cat("<Figma Document>", "\n\n", sep = "")
  cat(" * Number of canvas:", x$n_canvas, "\n")
  cat(" * Number of nodes:", x$n_nodes, "\n")
  invisible(x)
}


as_tibble <- function(x){
  if (inherits(x, "response")) {
    document <- as_figma_document(x)
  } else
  if (inherits(x, "figma_document")) {
    document <- x
  } else {
    msg <- paste0(c(
      "`as_tibble()` accepts objects of type `response` or `figma_document`. ",
      "However, a object of type %s was given."
    ), collapse = "")
    rlang::abort(sprintf(msg, class(x)))
  }

  canvas <- document$canvas
  list_of_tibbles <- vector("list", length = length(canvas))
  for (i in seq_along(canvas)) {
    canvas_metadata <- parse_canvas_metadata(canvas[[i]])
    objects_data <- parse_objects(canvas[[i]])
    data <- bind_tables(canvas_metadata, objects_data)
    list_of_tibbles[[i]] <- data
  }
  df <- dplyr::bind_rows(list_of_tibbles)
  df <- add_document_metadata(df, document)
  return(df)
}


add_document_metadata <- function(df, document){
  n <- nrow(df)
  attrs <- names(document$document)
  for (attr in attrs) {
    value <- document$document[[attr]]
    if (is.list(value)) {
      value <- lapply(seq_len(n), function(x) value)
    } else {
      value <- rep(value, times = n)
    }
    attr_name <- gsub("([A-Z])", "_\\1", attr, perl = TRUE)
    attr_name <- paste("document", tolower(attr_name), sep = "_")
    df[[attr_name]] <- value
  }
  df <- df |>
    dplyr::select(
      dplyr::starts_with("document"),
      dplyr::everything()
    )
  return(df)
}


parse_canvas_metadata <- function(canvas){
  attrs <- canvas[standard_attrs]
  n_objects <- length(canvas$children)
  df <- tibble::tibble(tempcol = seq_len(n_objects))
  for (attr in standard_attrs) {
    df[[attr]] <- rep(attrs[[attr]], times = n_objects)
  }
  df <- df |>
    dplyr::select(-tempcol) |>
    dplyr::rename(
      canvas_id = "id",
      canvas_name = "name",
      canvas_type = "type"
    )

  return(df)
}

bind_tables <- function(canvas_data, objects_data){
  n_objects <- nrow(objects_data)
  n_canvas <- nrow(canvas_data)
  if (n_objects == 0) {
    return(tibble::tibble())
  }
  if (n_objects != n_canvas) {
    msg <- paste0(c(
      "Objects dataframe have %d rows. However, Canvas dataframe have %d rows.",
      "Because of this inconsistency, we cannot bind these two dataframes together!"
    ), collapse = "\n")
    msg <- sprintf(msg, n_objects, n_canvas)
    rlang::abort(msg)
  }
  dplyr::bind_cols(canvas_data, objects_data)
}



parse_objects <- function(canvas){
  objects <- get_canva_objects(canvas)
  if (length(objects) == 0) {
    return(tibble::tibble())
  }
  build_objects_tibble(objects)
}


build_objects_tibble <- function(objects){
  table <- get_standard_attributes(objects)
  table <- table |>
    dplyr::mutate(
      object_attributes = get_nonstandard_attributes(objects)
    )

  return(table)
}

get_standard_attributes <- function(objects){
  attrs <- purrr::map(objects, ~.[standard_attrs])
  attrs <- purrr::transpose(attrs)
  attrs <- purrr::map(attrs, unlist) |>
    tibble::as_tibble() |>
    dplyr::rename(
      object_id = "id",
      object_name = "name",
      object_type = "type"
    )
  return(attrs)
}


get_nonstandard_attributes <- function(objects){
  nonstandard_attrs <- purrr::map(
    objects, find_nonstandard_attr
  )
  attrs <- purrr::map2(
    objects, nonstandard_attrs,
    `[`
  )
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
