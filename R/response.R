# Parse the response object returned by Figma API
#
# The functions present in this file are parser and helpers to parse the raw
# `response` object returned by the `httr` HTTP methods (e.g. `httr::GET()`).
# They generally read the data returned by the API, and try to fit this data
# into a R object of a specific type.



#' Default attributes of every Figma node
#'
#' Every Figma document is represented as a three of nodes, and, each node have
#' a different type (e.g. DOCUMENT, CANVAS, TEXT, etc.). However, despite their
#' differences in type, every node always has three default attributes, which
#' are stored in the \code{figma::default_attrs} object.
#' @export
default_attrs <- c("id", "name", "type")

#' Default document attributes of a Figma file
#'
#' Every Figma file have some default document attributes, that is, some informations
#' that describe the file, like its name, the last time it was modified, etc.
#' These default attributes are stored in the \code{figma::document_attrs} object.
#' @export
document_attrs <- c(
  "name", "components", "componentSets",
  "styles", "schemaVersion", "lastModified",
  "thumbnailUrl", "version", "role",
  "editorType", "linkAccess"
)


#' Parse the response data and fit it into a R object
#'
#' This function is usually called by \code{get_figma_file()},
#' \code{get_document_info()} and \code{get_figma_file_nodes()}, to process
#' the \code{response} object returned by the \code{httr} HTTP methods, such as
#' \code{httr::GET()}.
#'
#' @param response The \code{response} object returned by the \code{httr} HTTP
#' methods (e.g. \code{httr::GET()});
#' @param .output_format A string with the name of the output format choosen by the user;
#' @param ... Further arguments passed by the caller;
#'
#' @details
#' The functions from \code{figma} package adopts the philosophy to give, by
#' default, the most raw and unprocessed result possible to the user. Because
#' of it, \code{parse_response_object()} is usually called with
#' \code{.output_format = "response"}, which makes the function to just
#' return the input as is.
#'
#' This unprocessed and raw input gives all of the posibble information to
#' the user (which is good for debugging). But this information is usually in
#' a very messy and not friendly format, which makes harder for data analysis
#' and transformation pipelines.
#'
#' The \code{.output_format} argument provide an option for the user to choose
#' a more friendly format. As an example, with \code{.output_format = "tibble"},
#' \code{parse_response_object()} will call \code{figma:::as_tibble()} to
#' parse the data of the \code{response} object, and fit it into a
#' \code{tibble::tibble()} object.

parse_response_object <- function(response, .output_format, ...){
  check_for_http_errors(response)
  output_format <- check_output_format(.output_format)
  if (output_format == 'response') {
    return(response)
  }
  if (output_format == 'figma_document') {
    return(as_figma_document(response, ...))
  }
  if (output_format == 'tibble') {
    return(as_tibble(response, ...))
  }
}



#' Convert a \code{httr} response object to a Figma Document object
#'
#' This function receives a \code{httr::response()} object, and outputs a
#' \code{figma_document} object.
#'
#' @export
#' @details
#' A Figma Document is a just a R list with a more organized structure than the
#' raw content of the HTTP request in \code{httr::response()}. You can access
#' each part of this list with \code{`$`} and \code{`[[`} operators. To
#' understand what is in each element of this list (see Value section).
#'
#' @param response a `response` object produced by a `httr` HTTP method
#' (e.g. `httr::GET()`, `httr::POST()`, etc.);
#' @param ... Further arguments passed by the caller. Currently ignored by the
#' function;
#'
#' @returns
#' Returns an object of class \code{figma_document}, which is a R list with these elements:
#'
#' \itemize{
#' \item \strong{document}: a R list with all of the document metadata of the Figma file;
#' \item \strong{canvas}: a R list with all of the canvas and objects data of the Figma file;
#' \item \strong{n_canvas}: a integer with the number of canvas/pages of the Figma file;
#' \item \strong{n_objects}: a vector of integers with the number of objects in each canvas/page of the Figma file;
#' }
#'
#' @examples
#' \dontrun{
#' file_key <- "hch8YlkgaUIZ9raDzjPvCz"
#' token <- "my figma token secret ... "
#' # Returns a `response` object:
#' r <- figma::get_figma_file(file_key, token)
#' result <- figma::as_figma_document(r)
#' }
as_figma_document <- function(response, ...){
  if (!inherits(response, "response")) {
    stop("Object is not of type `response`!")
  }
  content <- httr::content(response)
  document <- content[document_attrs]
  document <- c(content$document[c("id", "type")], document)
  canvas <- content$document[["children"]]
  n_objects <- purrr::map_int(canvas, ~length(.[["children"]]))
  names(n_objects) <- paste("Canvas", seq_along(canvas))
  structure(
    list(document = document, canvas = canvas,
         n_canvas = length(canvas), n_objects = n_objects),
    class = "figma_document"
  )
}


#' @exportS3Method
print.figma_document <- function(x, ...){
  cat("<Figma Document>", "\n\n", sep = "")
  cat(" * Number of canvas:", x$n_canvas, "\n")
  cat(" * Number of objects in each canvas:", x$n_objects, "\n")
  invisible(x)
}


#' Convert a \code{httr} response object to a \code{tibble} object
#'
#' This function receives a \code{httr::response()} object, and outputs a
#' \code{tibble::tibble()} object.
#'
#' @export
#' @details
#' The function parses the data from the \code{response} object and tries to fit
#' it into a tibble object. Each row in the resulting tibble will be describing
#' an object in your Figma file.
#'
#' If \code{as_tibble()} receives a \code{response} object as input, it will call
#' \code{as_figma_document()} to convert this \code{response} object into a \code{figma_document}
#' object. But, \code{as_tibble()} can receive directly a \code{figma_document} object
#' and jump this step.
#'
#' If the Figma file have no objects draw in a specific canvas, \code{as_tibble()}
#' will return an empty \code{tibble} object for this specific canvas. This means that, if
#' your Figma file is a empty, or, in other words, if all of the canvas/pages of the
#' file have no objects draw in them, the final result of \code{as_tibble()} will
#' be an empty \code{tibble} object.
#'
#' By default, \code{figma::as_tibble()} does not include any document metadata in
#' the resulting tibble object. But you can pass \code{simplified = FALSE} to the
#' function to change this behaviour.
#'
#' @param x A Figma document object (i.e. a \code{figma::figma_document} object),
#' or, a \code{httr::response} object to parse;
#' @param ... Further arguments passed by the caller. Only \code{simplified}
#' argument is currently accepted, other arguments are ignored (See Details section);
#'
#' @returns
#' A \code{tibble::tibble()} object with all of the canvas and objects data of your
#' Figma file.
#'
#' @examples
#' \dontrun{
#' file_key <- "hch8YlkgaUIZ9raDzjPvCz"
#' token <- "my figma token secret ... "
#' # Returns a `response` object:
#' r <- figma::get_figma_file(file_key, token)
#' result <- figma::as_tibble(r)
#'
#' # To include all of the document metadata, use `simplified = FALSE`
#' result <- figma::as_tibble(r, simplified = FALSE)
#' }

as_tibble <- function(x, ...){
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

  dots <- list(...)
  simplified <- TRUE
  if ("simplified" %in% names(dots)) {
    simplified <- dots$simplified
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
  if (simplified) {
    return(df)
  } else {
    df <- add_document_metadata(df, document)
    return(df)
  }
}














parse_canvas_metadata <- function(canvas){
  attrs <- canvas[default_attrs]
  n_objects <- length(canvas$children)
  tempcol <- seq_len(n_objects)
  df <- tibble::tibble(tempcol = tempcol)
  for (attr in default_attrs) {
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


parse_objects <- function(canvas){
  objects <- get_canva_objects(canvas)
  if (length(objects) == 0) {
    return(tibble::tibble())
  }
  build_objects_tibble(objects)
}


parse_document_metadata <- function(figma_document, .output_format){
  document <- figma_document$document
  if (.output_format == "tibble") {
    tempcol <- 1L
    df <- tibble::tibble(tempcol = tempcol)
    attrs <- names(document)
    for (attr in attrs) {
      value <- document[[attr]]
      if (is.list(value)) {
        value <- list(value)
      }
      df[[attr]] <- value
    }
    df <- df |> dplyr::select(-tempcol)
    return(df)
  }

  return(document)
}










get_canva_objects <- function(canva){
  canva$children
}

build_objects_tibble <- function(objects){
  table <- get_default_attributes(objects)
  table <- table |>
    dplyr::mutate(
      object_attributes = get_nondefault_attributes(objects)
    )

  return(table)
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










get_default_attributes <- function(objects){
  attrs <- purrr::map(objects, ~.[default_attrs])
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


get_nondefault_attributes <- function(objects){
  nondefault_attrs <- purrr::map(
    objects, find_nondefault_attr
  )
  attrs <- purrr::map2(
    objects, nondefault_attrs,
    `[`
  )
  return(attrs)
}


find_nondefault_attr <- function(node){
  attr_names <- names(node)
  non_default_attrs <- attr_names[
    !(attr_names %in% default_attrs)
  ]
  return(non_default_attrs)
}












response_content <- function(response){
  httr::content(response, encoding = "UTF-8")
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


check_for_http_errors <- function(response, call = rlang::caller_env()){

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




report_http_error <- function(response, call = rlang::caller_env(n = 3)){

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
