
api_base_url <- "https://api.figma.com"
api_endpoints <- list(
  files = "/v1/files/"
)

implemented_endpoints <- names(api_endpoints)


#' Get the URL to each of the implemented endpoints of Figma API
#'
#' @param endpoint a string with the name of the desired endpoint;
#' @returns a string with the URL to the given endpoint.
#' @details
#'
#' This function accepts only single string values,
#' and, this string needs to be one of the values present
#' in \code{figma::implemented_endpoints}.
#'
#' The function checks if the user provided a NULL or NA value,
#' or, a vector of strings. If any of these cases occur,
#' the function will automatically prompt the user with an error.
#'
#' @examples
#' # Returns the URL to the `files` endpoint of Figma API
#' get_endpoint_url("files")
#'
get_endpoint_url <- function(endpoint){
  check_endpoint(endpoint)
  endpoint_url <- api_endpoints[[endpoint]]
  url <- paste0(api_base_url, endpoint_url)
  return(url)
}


check_endpoint <- function(endpoint){
  msg_components <- c(
    "The given endpoint was %s. ",
    "However, the `endpoint` argument should be a single string ",
    "with the name of the endpoint you want to use. ",
    "Check `print(figma::implemented_endpoints)` to see the available values ",
    "for `endpoint` argument."
  )
  msg_format <- paste(msg_components, collapse = "")

  if (is.null(endpoint) || is.na(endpoint)) {
    msg <- sprintf(msg_format, "a NULL or NA value")
    stop(msg)
  }

  if (length(endpoint) > 1) {
    msg <- sprintf(msg_format, "a vector")
    stop(msg)
  }

  if (!endpoint %in% implemented_endpoints) {
    msg <- sprintf(msg_format, endpoint)
    stop(msg)
  }
}


is_single_string <- function(x, argument_name){
  msg <- sprintf(
    "Argument `%s` should be a single string!",
    argument_name
  )
  is_empty <- is.null(x) || is.na(x) || length(x) == 0
  is_not_string <- !is.character(x)
  is_vector <- length(x) > 1
  if (is_empty || is_not_string || is_vector) {
    stop(msg)
  }
}



build_request_url <- function(base_url, path = NULL, query_string = NULL){
  url <- base_url
  if (is_not_null(path) && is.character(path)) {
    url <- add_paths_to_url(url, path)
  }
  if (is_not_null(query_string) && is.character(query_string)) {
    url <- add_query_string_to_url(url, query_string)
  }
  return(url)
}

is_not_null <- function(x){
  !is.null(x) && !is.na(x)
}

add_paths_to_url <- function(url, path){
  is_single_string(url, argument_name = "url")
  check_path(path)
  path <- sprintf("/%s/", path)
  url <- paste(url, path, collapse = "")
  return(url)
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

  if (!is.character) {
    msg <- sprintf(msg_format, path)
    stop(msg)
  }
}

add_query_string_to_url <- function(url, query_string) {
  return(url)
}
