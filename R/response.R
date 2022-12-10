# Parse the response object returned by Figma API
#
# The functions present in this file are parsers and helpers used to parse the raw
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


#' Select any of the elements in a object
#'
#' Safely select elements of a named object (like a named R list).
#' @details
#' This functions works in a similar way to \code{dplyr::any_of()}. It tries
#' to select any element of \code{x} that is in the vector given by the user
#' in the \code{elements} argument.
#'
#' In other words, if the user gives the vector \code{c("a", "c", "e")}, \code{select_any_of()}
#' will search for elements "a", "c" and "e" in the \code{x} object, and will select
#' any of these elements if it finds them.
#'
#' But \code{dplyr::any_of()} is designed to work with columns of a data.frame,
#' and \code{figma::select_any_of()} is designed to work specially with elements of a
#' named list (although it can be used to select columns of a data.frames as well).
#'
#' @param x A object with \code{names} attribute (usually a named R list);
#' @param elements A vector of strings with the name of the elements to search for;
#'
#' @return A subset of the \code{x} if it finds any of the elements described in the
#'   \code{element} argument.

select_any_of <- function(x, elements){
  available_elements <- names(x)
  selected_elements <- elements[
    elements %in% available_elements
  ]
  return(x[selected_elements])
}


#' Parse the response data and fit it into a R object
#'
#' This function is usually called by \code{get_figma_file()},
#' \code{get_document_info()} and \code{get_figma_page()}, to process
#' the \code{response} object returned by the \code{httr} HTTP methods, such as
#' \code{httr::GET()}.
#'
#' @param response The \code{response} object returned by the \code{httr} HTTP
#' methods (e.g. \code{httr::GET()});
#' @param .output_format A string with the name of the output format chosen by the user;
#' @param ... Further arguments passed by the caller;
#'
#' @details
#' The functions from \code{figma} package adopts the philosophy to give, by
#' default, the most raw and unprocessed result possible to the user. Because
#' of it, \code{parse_response_object()} is usually called with
#' \code{.output_format = "response"}, which makes the function to just
#' return the input as is.
#'
#' This unprocessed and raw input gives all of the possible information to
#' the user (which is good for debugging). But this information is usually in
#' a very messy and not friendly format, which makes harder for data analysis
#' and transformation pipelines.
#'
#' The \code{.output_format} argument provide an option for the user to choose
#' a more friendly format. As an example, with \code{.output_format = "tibble"},
#' \code{parse_response_object()} will call \code{figma::as_tibble()} to
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
#' each part of this list with \code{`$`} and \code{`[[`} operators. See Value section to
#' understand what is in each element of this list.
#'
#' \code{as_figma_document()} will call different parsers depending on what kind
#' of elements are present in the content of the \code{response} object it receives
#' as input. These elements define what kind of data is present in the \code{response}
#' object, and how it is structured.
#'
#' If this input object have a \code{document} element in the top-level of
#' the content, is likely that this input object was produced by \code{figma::get_figma_file()}.
#' In this case, \code{as_figma_document()} will call \code{figma:::parse_figma_file()} to parse
#' the contents of the HTTP request.
#'
#' In the other hand, if this input object have a \code{nodes} element in the top-level of
#' the content, is likely that this input object was produced by \code{figma::get_figma_page()}.
#' In this case, \code{as_figma_document()} will call \code{figma:::parse_figma_page()} to parse
#' the contents of the HTTP request.
#'
#' If none of these key elements ("document" or "nodes") are found in the top-level of the
#' content of the \code{response} object, \code{as_figma_document()} will issue an error
#' to the user, telling it could not recognize the source of the \code{response} object.
#'
#' @param response a \code{response} object produced by a \code{httr} HTTP method
#'   (e.g. \code{httr::GET()}, \code{httr::POST()}, etc.);
#' @param ... Further arguments passed by the caller. Currently ignored by the
#'   function;
#'
#' @returns
#' Returns an object of class \code{figma_document}, which is a R list with these elements:
#'
#' \itemize{
#' \item \strong{document}: a R list with all of the document metadata of your Figma file;
#' \item \strong{canvas}: a R list with all of the canvas and objects data of your Figma file;
#' \item \strong{n_canvas}: a integer with the number of canvas/pages in your Figma file;
#' \item \strong{n_objects}: a vector of integers with the number of objects in each canvas/page of your Figma file;
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
    rlang::abort("Input object is not of type `response`!")
  }
  content <- httr::content(response)
  if ("document" %in% names(content)) {
    r <- parse_figma_file(content)
    return(r)
  }
  if ("nodes" %in% names(content)) {
    r <- parse_figma_pages(content)
    return(r)
  }

  report_unrecognized_source(content)
}


#' @exportS3Method
print.figma_document <- function(x, ...){
  cat("<Figma Document>", "\n\n", sep = "")
  cat(" * Number of canvas:", x$n_canvas, "\n")
  cat(" * Number of objects in each canvas:", x$n_objects, "\n")
  invisible(x)
}




parse_figma_file <- function(content){
  document <- select_any_of(content, document_attrs)
  document <- c(content$document[c("id", "type")], document)
  canvas <- content$document[["children"]]
  for (i in seq_along(canvas)) {
    names(canvas[[i]])[names(canvas[[i]]) == "children"] <- "objects"
  }
  n_objects <- purrr::map_int(canvas, ~length(.[["objects"]]))
  names(n_objects) <- paste("Canvas", seq_along(canvas))
  structure(
    list(document = document, canvas = canvas,
         n_canvas = length(canvas), n_objects = n_objects),
    class = "figma_document"
  )
}



parse_figma_pages <- function(content){
  document <- select_any_of(content, document_attrs)
  canvas <- content$nodes
  canvas <- purrr::map(canvas, ~.[["document"]])
  for (i in seq_along(canvas)) {
    names(canvas[[i]])[names(canvas[[i]]) == "children"] <- "objects"
  }
  n_objects <- purrr::map_int(canvas, ~length(.[["objects"]]))
  names(n_objects) <- paste("Canvas", seq_along(canvas))
  structure(
    list(document = document, canvas = canvas,
         n_canvas = length(canvas), n_objects = n_objects),
    class = "figma_document"
  )
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
#' your Figma file is empty, or, in other words, if all of the canvas/pages of the
#' file have no objects draw in them, the final result of \code{as_tibble()} will
#' be an empty \code{tibble} object.
#'
#' By default, \code{figma::as_tibble()} does not include any document metadata in
#' the resulting tibble object. But you can pass \code{simplified = FALSE} to the
#' function to change this behavior.
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
  document <- prepare_object(x)
  tibble <- tibble::tibble(
      canvas = document$canvas
    ) |>
    unnest_canvas() |>
    unnest_objects()

  dots <- list(...)
  simplified <- dots$simplified
  if (isFALSE(simplified)) {
    tibble <- add_document_metadata(tibble, document)
  }

  return(tibble)
}

prepare_object <- function(x, call = rlang::caller_env()){
  if (inherits(x, "response")) {
    return(as_figma_document(x))
  } else
  if (inherits(x, "figma_document")) {
    return(x)
  } else {
    reason <- "Input object type is not supported!"
    msg <- paste0(c(
      "`as_tibble()` accepts an object of class `response` or `figma_document`. ",
      "However, an object of class `%s` was given."
    ), collapse = "")
    rlang::abort(c(reason, sprintf(msg, class(x))), call = call)
  }
}

unnest_canvas <- function(df, ...){
  df <- do.call(
    tidyr::hoist,
    args = c(
      list(df, "canvas"),
      as.list(c(default_attrs, "objects"))
    )
  )

  df <- df |>
    dplyr::rename(
      canvas_id = "id",
      canvas_name = "name",
      canvas_type = "type"
    ) |>
    dplyr::select(-c("canvas"))

  return(df)
}


unnest_objects <- function(df, ...){
  df <- df |>
    tidyr::unnest_longer(col = objects) |>
    dplyr::rename(
      object_attrs = "objects"
    )

  df <- do.call(
      tidyr::hoist,
      args = c(
        list(df, "object_attrs"),
        as.list(default_attrs)
      )
    ) |>
    dplyr::rename(
      object_id = "id",
      object_name = "name",
      object_type = "type"
    )

  return(df)
}



document_metadata <- function(x, attrs = default_attrs){
  metadata <- x$document
  if (!is.null(attrs)) {
    metadata <- select_any_of(metadata, attrs)
  }
  n <- names(metadata)
  names(metadata) <- paste("document", n, sep = "_")
  return(metadata)
}

add_document_metadata <- function(df, document){
  dm <- document_metadata(document)
  df <- do.call(
      dplyr::mutate,
      args = c(list(df), dm)
    ) |>
    dplyr::select(
      dplyr::starts_with("document"),
      dplyr::everything()
    )

  return(df)
}









check_output_format <- function(format, call = rlang::caller_env()){
  allowed_formats <- c('response', 'figma_document', 'tibble')
  if ( !(format %in% allowed_formats) ) {
    reason <- sprintf("Output format '%s' not allowed!", format)
    formats <- sprintf("'%s'", allowed_formats)
    formats <- paste0(formats, collapse = ", ")
    msg <- paste0(sprintf("Choose one of the following options: %s", formats))
    rlang::abort(c(reason, msg), call = call)
  }
  return(format)
}


check_for_http_errors <- function(response, call = rlang::caller_env()){

  if (!inherits(response, "response")) {
    rlang::abort(
      "Object given to `response` is not of class `response`!",
      call = call
    )
  }
  if (response$status_code != 200) {
    report_http_error(response)
  }
}


report_http_error <- function(response, call = rlang::caller_env(n = 3)){
  content <- httr::content(response, encoding = "UTF-8")
  header <- "HTTP Error:\n"
  url <- sprintf(
    "* URL used in the request: %s", response$url
  )
  status <- sprintf(
    "* Status code returned by the API: %s", response$status_code
  )
  error_message <- sprintf(
    "* Error message returned by the API: %s", content$err
  )
  headers <- sprintf(
    "* Headers returned by the API:\n%s",
    response$all_headers[[1]] |>
      utils::str() |>
      utils::capture.output() |>
      paste0(collapse = "\n")
  )

  msg <- c(header, url, status, error_message, headers)
  rlang::abort(msg, call = call)
}




report_unrecognized_source <- function(content, call = rlang::caller_env()){
  reason <- "Unrecognized source of the `response` object!"
  elements <- paste0(names(content), collapse = ", ")
  msg <- c(
    "`as_figma_document()` expected to find a `document` (or `nodes`) element ",
    "in the most top-level part of the content section of the `response` object. ",
    "However, the input `response` object have the following elements inside its `content` element: %s"
  )
  msg <- sprintf(paste0(msg, collapse = ""), elements)
  rlang::abort(c(reason, msg), call = call)
}
