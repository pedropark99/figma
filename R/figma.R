#' Get a Figma File from the API
#'
#' Use the \code{/v1/files/} endpoint of Figma API to get a Figma File as an R object.
#'
#'
#' You can easily get the key of your Figma File from the URL of this file.
#'
#' @param file_key A string with the key of the Figma File you want to get;
#' @param token A string with your personal Figma token to authenticate in the API;
#'
#' @returns A Figma Document object (i.e. a object of class `figma_document`);
get_figma_file <- function(file_key, token){
  url <- get_endpoint_url(endpoint = "files")
  url <- build_request_url(url, path = file_key)
  header <- httr::add_headers(
    "X-Figma-Token" = token
  )
  r <- httr::GET(url = url, header)
  return(as_figma_document(r))
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




