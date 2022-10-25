
api_base_url <- "https://api.figma.com"
api_endpoints <- list(
  files = "/v1/files/"
)

implemented_endpoints <- names(api_endpoints)


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

#' Get the URL to each of the implemented endpoints of Figma API
#'
#' @param endpoint a string with the name of one of
get_endpoint_url <- function(endpoint){
  check_endpoint(endpoint)
  endpoint_url <- api_endpoints[[endpoint]]
  url <- paste0(api_base_url, endpoint_url)
  return(url)
}


check_endpoint <- function(endpoint){
  msg_components <- c(
    "The given endpoint is %s. ",
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

  if (length(endpoint) != 1) {
    msg <- sprintf(msg_format, "a vector of strings")
    stop(msg)
  }

  if (!endpoint %in% implemented_endpoints) {
    msg <- sprintf(msg_format, endpoint)
    stop(msg)
  }
}
