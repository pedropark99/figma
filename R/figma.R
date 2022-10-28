#' Get data of a Figma File from the API
#'
#' This function uses the \code{/v1/files/} endpoint of Figma API
#' to get all of the data of a particular Figma File, and fit it
#' into a R object.
#'
#' @details
#' With this function you can bring all of the data of your
#' Figma file into R. By default, \code{get_figma_file()} returns
#' a `response` object with all of the data returned by the API.
#' That is, not only the data of your file, but, all of the data
#' from the HTTP request.
#'
#' Although this format might be useful (specially because it
#' brings all of the available data), you might want a more "formatted"
#' (or friendly) output. In this case, you can use the \code{.output_format}
#' argument to get a different output format.
#'
#' With \code{.output_format = "figma_document"}, \code{get_figma_file()}
#' returns a Figma Document object
#' (i.e. a object of class \code{figma_document}).
#'
#' With \code{.output_format = "tibble"}, \code{get_figma_file()}
#' will use \code{figma::as_tibble()} to parse the output from
#' the API to fit into a \code{tibble::tibble()} object. If you
#' use this output format, you can also use the \code{simplified}
#' argument to control if document metadata should be present
#' in the resulting \code{tibble} (See examples section)
#'
#' By default, \code{simplified} is set to \code{TRUE}. With this
#' configuration \code{get_figma_file()} outputs a tibble with
#' all the objects data from your Figma file, and their corresponding
#' canvas metadata. However, it does not include any metadata from
#' the document per se.
#'
#' In other words, with \code{simplified = TRUE} you get all the data
#' of the objects from each canvas in your Figma file, but you do
#' not get any metadata from the document. That is okay, because you
#' usually do not need these informations. But if you want them in
#' the resulting tibble, pass \code{simplified = FALSE};
#'
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
#' can change this behaviour with \code{.output_format} argument (See Details
#' section for more information).
#'
#' With \code{.output_format = "tibble"}, a \code{tibble::tibble()} object
#' is returned. With \code{.output_format = "figma_document"}, a object of
#' class \code{figma_document} is returned.
#'
#' @examples
#' \dontrun{
#' file_key <- "hch8YlkIrYbU3raDzjPvCz"
#' token <- "my figma token secret ... "
#' # Returns a `response` object:
#' result <- get_figma_file(file_key, token)
#' # Returns a `tibble` object:
#' result <- get_figma_file(
#'   file_key, token, .output_format = "tibble"
#' )
#' # Returns the same `tibble` object as before
#' # but, now, with all the metadata from the
#' # Figma document too:
#' result <- get_figma_file(
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


get_document_info <- function(file_key, token, .output_format = "list"){
  r <- get_figma_file(
    file_key,
    token,
    .output_format = "figma_document"
  )
  r <- parse_document_metadata(r, .output_format)
  return(r)
}


get_figma_file_nodes <- function(file_key, node_id, token){
  url <- get_endpoint_url(endpoint = "file_nodes")
  url <- build_request_url(
    url,
    path = c(file_key, "nodes"), ids = node_id
  )
  header <- httr::add_headers(
    "X-Figma-Token" = token
  )
  r <- httr::GET(url = url, header)
  return(r)
}




