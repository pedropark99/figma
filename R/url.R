#' Figma API infos and handlers to URLs
#'
#' This file contains all functions for basic
#' URL manipulation, and, global variables that stores
#' basic informations of the Figma API, like the base URL
#' of the API, and the implemented endpoints in this
#' package.
#'
#'
#'
api_base_url <- "https://api.figma.com"
api_endpoints <- list(
  files = "/v1/files",
  file_nodes = "/v1/files"
)

implemented_endpoints <- names(api_endpoints)


#' Get the URL to each of the implemented endpoints of Figma API
#'
#' @param endpoint a single string with the name of the desired endpoint;
#' @returns a string with the URL to the given endpoint.
#' @details
#'
#' This function accepts only single string values,
#' and, this string needs to be one of the values present
#' in \code{figma::implemented_endpoints}.
#'
#' If the user provided a NULL or NA value,
#' or, a vector of strings, the function will
#' automatically prompt the user with an error.
#'
#' @examples
#' # Returns the URL to the `files` endpoint of Figma API
#' get_endpoint_url("files")
#'
get_endpoint_url <- function(endpoint){
  check_endpoint(endpoint)
  endpoint_url <- api_endpoints[[endpoint]]
  url <- paste0(api_base_url, endpoint_url, collapse = "")
  return(url)
}


#' Check the \code{endpoint} argument
#'
#' Check if the provided value to the \code{endpoint}
#' argument.
#'
#' This function checks if the \code{endpoint} argument
#' is:
#'
#' \itemize{
#'   \item{A single string value;}
#'   \item{One of the values in \code{figma::implemented_endpoints};}
#' }
#'
#' @param endpoint a single string value;
#' @examples
#' # Will work:
#' check_endpoint("files")
#' \dontrun{
#' # Will not work, because is a number
#' check_endpoint(1)
#' # Will not work, because is a vector
#' check_endpoint(c("a", "b", "c"))
#' # Will not work, because there is no "rectangle" endpoint implemented
#' check_endpoint("rectangle")
#' }
check_endpoint <- function(endpoint){
  msg_components <- c(
    "The given endpoint was %s. ",
    "However, the `endpoint` argument should be a single string ",
    "with the name of the endpoint you want to use. ",
    "Check `print(figma::implemented_endpoints)` to see the available values ",
    "for `endpoint` argument."
  )
  msg_format <- paste(msg_components, collapse = "")

  not_a_single_string <- !is_single_string(endpoint)
  not_implemented <- !endpoint %in% implemented_endpoints

  if (not_implemented || not_a_single_string) {
    stop(sprintf(msg_format, endpoint))
  }
}



is_single_string <- function(x){
  is.character(x) && length(x) == 1
}


#' Build the request URL
#'
#' This function adds "components" to a base URL, to compose
#' the complete URL that will be used in the HTTP request.
#'
#' @param base_url A single string with the base URL that you want add components to;
#' @param path A vector of strings (or a single string) with "path" components;
#' @param ... key value pairs that will compose the query string section of the URL;
#'
#'
build_request_url <- function(base_url, path = NULL, ...){
  url <- base_url
  if (is_not_null(path) && is.character(path)) {
    url <- add_paths_to_url(url, path)
  }
  url <- add_query_string_to_url(url, ...)
  return(url)
}

is_not_null <- function(x){
  !is.null(x) && !is.na(x)
}

add_paths_to_url <- function(url, path){
  check_single_string(url, argument_name = "url")
  check_path(path)
  path <- paste0(path, collapse = "/")
  path <- sprintf("/%s/", path)
  url <- paste0(url, path, collapse = "")
  return(url)
}


check_single_string <- function(x, argument_name){
  msg <- sprintf(
    "Argument `%s` should be a single string!",
    argument_name
  )
  if ( !is_single_string(x) ) {
    stop(msg)
  }
}

check_path <- function(path){
  msg_components <- c(
    "The given path was %s. ",
    "However `path` should be a single string, or, a vector of strings."
  )
  msg_format <- paste(msg_components, collapse = "")

  if (is.null(path) || is.na(path)) {
    msg <- sprintf(msg_format, "a NULL or NA value!")
    stop(msg)
  }

  if (!is.character(path)) {
    msg <- sprintf(msg_format, path)
    stop(msg)
  }
}

add_query_string_to_url <- function(url, ...){
  parameters <- list(...)
  if (length(parameters) == 0) {
    return(url)
  }
  if (is.null(names(parameters)) || any(names(parameters) == "")) {
    msg <- c(
      "Looks like you provided unnamed arguments to `...`. ",
      "You need to make sure that all arguments passed to `...` ",
      "are named arguments (i.e. have a key value pair)."
    )
    stop(paste0(msg, collapse = ""))
  }
  query_string <- build_query_string(parameters)
  url <- paste0(
    url, "?", query_string,
    collapse = ""
  )
  return(url)
}



build_query_string <- function(parameters){
  keys <- names(parameters)
  key_value_pairs <- vector("character", length(parameters))
  for (i in seq_along(parameters)) {
    key <- keys[i]
    value <- parameters[[i]]
    key_value_pairs[i] <- sprintf("%s=%s", key, value)
  }
  query_string <- paste0(key_value_pairs, collapse = "&")
  return(query_string)
}



