#' Get data of a Figma File from the API
#'
#' This function uses the \code{/v1/files/} endpoint of Figma API to get all of
#' the data of a particular Figma file, and fit it into a R object.
#'
#' @export
#' @details
#' With this function you can bring all of the data of your Figma file into R.
#' By default, \code{get_figma_file()} returns a `response` object with all of
#' the data returned by the API. That is, not only the data of your Figma file,
#' but also, the data from the HTTP request.
#'
#' All of your Figma file data is in the \code{content} element of
#' the `response` object. However, by default, the Figma API returns this data in
#' \code{raw} format (that is, as raw bytes). To convert these bytes into a
#' useful object (like a JSON object, or a character vector, or a list), is
#' highly recommended to apply the \code{httr::content()} function over this
#' \code{content} element.
#'
#' Although this being a useful output format (i.e. `response` object)
#' (specially because it brings all of the available data), you might want
#' a more "formatted" (or friendly) output. In this case, you can use the
#' \code{.output_format} argument to get a different output format.
#'
#' With \code{.output_format = "figma_document"}, \code{get_figma_file()}
#' use \code{figma::as_figma_document()} to convert the `response` object
#' into a Figma Document object (i.e. a object of class \code{figma_document}),
#' and returns it as the output. This \code{figma_document} object, is a normal
#' R list, with only the data of your Figma file (See documentation of
#' \code{figma::as_figma_document()} for more details).
#'
#' With \code{.output_format = "tibble"}, \code{get_figma_file()} will use
#' \code{figma::as_tibble()} to parse the output from the API to fit into a
#' \code{tibble::tibble()} object. If you use this output format, you can also
#' use the \code{simplified} argument to control if document metadata should be
#' present in the resulting \code{tibble} (See examples section).
#'
#' By default, \code{simplified} is set to \code{TRUE}, so \code{get_figma_file()}
#' outputs a tibble with all the objects data from your Figma file, and their
#' corresponding canvas metadata. However, it does not include any metadata from
#' the document per se.
#'
#' In other words, with \code{simplified = TRUE} you get all the data of the
#' objects from each canvas in your Figma file, but you do not get any metadata
#' from the document. That is okay, because you usually do not need these
#' informations.
#'
#' But if you want them in the resulting tibble, pass \code{simplified = FALSE}
#' to \code{get_figma_file()}. If you want just the document metadata (and not
#' the canvas or objects data), you might want to use the \code{get_document_info()}
#' function instead of \code{get_figma_file()} (See \code{get_document_info()}
#' documentation for more details).
#'
#' @section Be aware of possible HTTP errors:
#' To get the data of your Figma file, the functions from \code{figma} package make a HTTP
#' request to the Figma API. But this request can fail for a number of reasons, and if this
#' does happen, \code{get_figma_file()} will use \code{report_http_error()} to raise an error
#' and report to the user, what kind of error message the Figma API returned.
#' See \code{vignette("http-errors")} for more details.
#'
#' @param file_key A string with the key of the Figma File you want to get;
#' @param token A string with your personal Figma token to authenticate in the API;
#' @param geometry A boolean value indicating if you want to export vector data.
#'   Defaults to FALSE;
#' @param .output_format The output format. Options are \code{"response",
#'   "figma_document", "tibble"}. Defaults to \code{"response"};
#' @param ... Further arguments that are passed to \code{parse_response_object()};
#'
#' @returns By default, \code{get_figma_file()} do not parse the output from
#' the API, and returns the raw \code{response} object
#' produced by the \code{httr} HTTP methods (e.g. \code{httr::GET()}).
#'
#' But you can change this behavior with \code{.output_format} argument. With
#' \code{.output_format = "tibble"}, a \code{tibble::tibble()} object
#' is returned. With \code{.output_format = "figma_document"}, a object of
#' class \code{figma_document} is returned (See Details
#' section for more information).
#'
#' @seealso
#'   \code{\link{as_tibble}}
#'
#'   \code{\link{as_figma_document}}
#'
#' @examples
#' \dontrun{
#' library(figma)
#'
#' file_key <- "hch8YlkgaUIZ9raDzjPvCz"
#' token <- "my figma token secret ... "
#'
#' # Returns a `response` object:
#' result <- figma::get_figma_file(file_key, token)
#'
#' # Returns a `tibble` object:
#' result <- figma::get_figma_file(
#'   file_key, token, .output_format = "tibble"
#' )
#'
#' # Returns the same `tibble` object as before
#' # but, now, with all the metadata from the
#' # Figma document too:
#' result <- figma::get_figma_file(
#'   file_key, token,
#'   .output_format = "tibble",
#'   simplified = FALSE
#' )
#'
#' # Returns a `figma_document` object:
#' result <- figma::get_figma_file(
#'   file_key, token, .output_format = "figma_document"
#' )
#' }

get_figma_file <- function(file_key,
                           token,
                           geometry = FALSE,
                           .output_format = "response",
                           ...){
  url <- get_endpoint_url(endpoint = "files")
  url_args <- list(path = file_key)
  if (isTRUE(geometry)) {
    url_args$geometry <- "paths"
  }
  url <- do.call(
    build_request_url,
    args = c(list(base_url = url), url_args)
  )
  header <- httr::add_headers("X-Figma-Token" = token)
  r <- httr::GET(url = url, header)
  r <- parse_response_object(r, .output_format, ...)
  return(r)
}





#' Get the document metadata of a Figma File from the API
#'
#' This function uses the \code{/v1/files/} endpoint of Figma API
#' to get all of the document metadata of a particular Figma file,
#' and fit it into a R object.
#'
#' @export
#' @inheritParams get_figma_file
#' @param .output_format The output format. Options are \code{"list"} and
#' \code{"tibble"}. Defaults to \code{"list"};
#'
#' @section Be aware of possible HTTP errors:
#' To get the data of your Figma file, the functions from \code{figma} package make a HTTP
#' request to the Figma API. But this request can fail for a number of reasons, and if this
#' does happen, \code{get_document_info()} will use \code{report_http_error()} to raise an error
#' and report to the user, what kind of error message the Figma API returned.
#' See \code{vignette("http-errors")} for more details.
#'
#' @returns
#' By default, \code{get_document_info()} returns a raw R list with all
#' of the document metadata of your Figma file. But you can change this
#' behavior with \code{.output_format = "tibble"}, which gives you
#' a \code{tibble::tibble} object.
#'
#' @details
#' You may not be interested in the contents of a Figma file, but in the
#' metadata of this file instead. That is, you want to know the "name"
#' of a particular Figma file, the last time it was modified, which version
#' it uses, etc.
#'
#' That is why \code{get_document_info()} exists. It collects just the
#' metadata of your Figma file, and ignores all canvas and objects data.
#'
#' By default, \code{get_document_info()} fits the metadata into a raw R list.
#' But you can change this behavior with the \code{.output_format} argument.
#' With \code{.output_format = "tibble"}, \code{get_document_info()} will
#' fit the metadata into a \code{tibble::tibble} object.
#'
#' @examples
#' \dontrun{
#' library(figma)
#' file_key <- "hch8YlkgaUIZ9raDzjPvCz"
#' token <- "my figma token secret ... "
#' # Returns a list with the metadata:
#' result <- figma::get_document_info(file_key, token)
#' # Returns a `tibble` object:
#' result <- figma::get_document_info(
#'   file_key, token,
#'   .output_format = "tibble"
#' )
#' }

get_document_info <- function(file_key, token, .output_format = "list"){
  r <- get_figma_file(
    file_key,
    token,
    .output_format = "figma_document"
  )
  r <- document_metadata(r, attrs = NULL)
  return(r)
}





#' Get data of a specific canvas/page in a Figma File from the API
#'
#' This function uses the \code{/v1/files/} endpoint of Figma API
#' to get the data of an specific canvas/page (or a set of canvas/pages) from a Figma file,
#' and fit it into a R object.
#'
#' @details
#'
#' With `get_figma_file()` you get data of all objects in all canvas/pages of your Figma file.
#' But with `get_figma_page()` you get data of all objects drawn in a specific set of canvas/pages
#' of your Figma file.
#'
#' Every canvas/page in a Figma file, is identified by a node ID. You can easily get this ID
#' from the URL that appears in your browser when you access this canvas/page on the
#' Figma platform (See \code{vignette("figma")} for more details).
#'
#' After you collected this node ID, give it to \code{node_id} argument as a string. If
#' you want to collect data from more than one canvas/page of your Figma file, give a vector
#' of node IDs to \code{node_id} argument.
#'
#' @export
#' @inheritParams get_figma_file
#' @param node_ids A string with the node ID (or a vector of strings with node IDs);
#'
#' @section Be aware of possible HTTP errors:
#' To get the data of your Figma file, the functions from \code{figma} package make a HTTP
#' request to the Figma API. But this request can fail for a number of reasons, and if this
#' does happen, \code{get_figma_page()} will use \code{report_http_error()} to raise an error
#' and report to the user, what kind of error message the Figma API returned.
#' See \code{vignette("http-errors")} for more details.
#'
#' @returns By default, \code{get_figma_page()} do not parse the output from
#' the API, and returns the raw \code{response} object
#' produced by the \code{httr} HTTP methods (e.g. \code{httr::GET()}).
#'
#' But you can change this behavior with \code{.output_format} argument. With
#' \code{.output_format = "tibble"}, a \code{tibble::tibble()} object
#' is returned. With \code{.output_format = "figma_document"}, a object of
#' class \code{figma_document} is returned (See Details
#' section for more information).
#'
#' @examples
#' \dontrun{
#' library(figma)
#' file_key <- "hch8YlkgaUIZ9raDzjPvCz"
#' token <- "my figma token secret ... "
#' node_id <- "0%3A1"
#' result <- figma::get_figma_page(
#'   file_key, token, node_id
#' )
#' }


get_figma_page <- function(file_key,
                           token,
                           node_ids,
                           geometry = FALSE,
                           .output_format = "response",
                           ...){
  url <- get_endpoint_url(endpoint = "file_nodes")
  node_ids <- paste0(node_ids, collapse = ",")
  url_args <- list(path = c(file_key, "nodes"), ids = node_ids)
  if (isTRUE(geometry)) {
    url_args$geometry <- "paths"
  }
  url <- do.call(
    build_request_url,
    args = c(list(base_url = url), url_args)
  )
  header <- httr::add_headers("X-Figma-Token" = token)
  r <- httr::GET(url = url, header)
  r <- parse_response_object(r, .output_format, ...)
  return(r)
}




