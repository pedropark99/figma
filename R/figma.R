#' Get data of a Figma File from the API
#'
#' This function uses the \code{/v1/files/} endpoint of Figma API to get all of
#' the data of a particular Figma file, and fit it into a R object.
#'
#' @export
#' @details
#' With this function you can bring all of the data of yourFigma file into R.
#' By default, \code{get_figma_file()} returns a `response` object with all of
#' the data returned by the API. That is, not only the data of your Figma file,
#' but also, the data from the HTTP request.
#'
#' All of the data from your Figma file is in the \code{content} element of
#' the `response` object. However, by default, the Figma API returns this data in
#' \code{raw} format (that is, as raw bytes). To convert these bytes into a
#' useful object (like a JSON object, or a character vector, or a list), is
#' highly recomended to apply the \code{httr::content()} function over this
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
#' @param file_key A string with the key of the Figma File you want to get;
#' @param token A string with your personal Figma token to authenticate in the API;
#' @param .output_format The output format. Options are \code{"response",
#' "figma_document", "tibble"}. Defaults to \code{"response"};
#' @param ... Further arguments that are passed to \code{parse_response_object()};
#'
#' @returns By default, \code{get_figma_file()} do not parse the output from
#' the API, and returns the raw \code{response} object
#' produced by the \code{httr} HTTP methods (e.g. \code{httr::GET()}). But you
#' can change this behaviour with \code{.output_format} argument. With
#' \code{.output_format = "tibble"}, a \code{tibble::tibble()} object
#' is returned. With \code{.output_format = "figma_document"}, a object of
#' class \code{figma_document} is returned (See Details
#' section for more information).
#'
#' @seealso
#'   \code{\link{figma::as_tibble}}
#'
#'   \code{\link{figma::as_figma_document}}
#'
#' @examples
#' \dontrun{
#' library(figma)
#' file_key <- "hch8YlkgaUIZ9raDzjPvCz"
#' token <- "my figma token secret ... "
#' # Returns a `response` object:
#' result <- figma::get_figma_file(file_key, token)
#' # Returns a `tibble` object:
#' result <- figma::get_figma_file(
#'   file_key, token, .output_format = "tibble"
#' )
#' # Returns the same `tibble` object as before
#' # but, now, with all the metadata from the
#' # Figma document too:
#' result <- figma::get_figma_file(
#'   file_key, token,
#'   .output_format = "tibble",
#'   simplified = FALSE
#' )
#' }

get_figma_file <- function(file_key,
                           token,
                           .output_format = "response",
                           ...){
  url <- get_endpoint_url(endpoint = "files")
  url <- build_request_url(url, path = file_key)
  header <- httr::add_headers(
    "X-Figma-Token" = token
  )
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
#' @returns
#' By default, \code{get_document_info()} returns a raw R list with all
#' of the document metadata of your Figma file. But you can change this
#' behaviour with \code{.output_format = "tibble"}, which gives you
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
#' By default, \code{get_document_info()} fits the metada into a raw R list.
#' But you can change this behaviour with the \code{.output_format} argument.
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
  r <- parse_document_metadata(r, .output_format)
  return(r)
}





#' Get data of a set of objects in a Figma File from the API
#'
#' This function uses the \code{/v1/files/} endpoint of Figma API
#' to get the data of an specific object (or a set of objects) from a Figma file,
#' and fit it into a R object.
#'
#' @details
#' Every object draw in a canvas/page of a Figma file, is represented as a node in
#' the canvas on which it was drawn. Because of this notion, to identify the specific
#' object (or "node") that you want to search, you need to give the ID code that identifies
#' this specific object in the canvas.
#'
#' You can easily get this ID from the URL that appears in your browser when
#' you select this specific object. See vignette.
#'
#' @export
#' @inheritParams get_figma_file
#' @param node_id A string with the node ID (or a vector of strings with node IDs);
#'


get_figma_objects <- function(file_key, token, node_id, .output_format = "response", ...){
  url <- get_endpoint_url(endpoint = "file_nodes")
  url <- build_request_url(
    url,
    path = c(file_key, "nodes"), ids = node_id
  )
  header <- httr::add_headers(
    "X-Figma-Token" = token
  )
  r <- httr::GET(url = url, header)
  r <- parse_response_object(r, .output_format, ...)
  return(r)
}




