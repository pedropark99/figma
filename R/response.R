#' Parse the response object returned by Figma API
#'
#'

response_content <- function(response){
  httr::content(response, encoding = "UTF-8")
}


parse_response_object <- function(response){
  check_for_http_erros(response)
}

check_for_http_erros <- function(response){
  if (!httr:::is.response(response)) {
    stop("Object given to `response` is not of type `response`!")
  }
  if (response$status_code != 200) {
    report_http_error(response)
  }
}

report_http_error <- function(response){
  content <- response_content(response)
  cat("HTTP Error:\n\n", file = stderr())
  cat(
    "* Status code returned by the API: ", response$status_code, "\n",
    sep = "", file = stderr()
  )
  cat(
    "* Error message returned by the API: ", content$err, "\n",
    sep = "", file = stderr()
  )
  cat("* Headers returned by the API:\n", file = stderr())
  cat(utils::str(response$all_headers[[1]]), file = stderr())
  stop("The status code returned by the HTTP request is different from 200!")
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
  content <- response_content(response)$document
  n_canvas <- length(content$children)
  n_nodes <- purrr::map_int(content$children, length)
  names(n_nodes) <- paste("Canvas", seq_along(content$children))
  structure(
    list(name = "Figma Document", n_canvas = n_canvas,
         n_nodes = n_nodes, content = content),
    class = "figma_document"
  )
}


#' Print method for Figma Document objects
#' @exportS3Method
print.figma_document <- function(x, ...){
  cat("<Figma Document>", "\n\n", sep = "")
  cat(" * Number of canvas:", x$n_canvas, "\n")
  cat(" * Number of nodes:", x$n_nodes, "\n")
  invisible(x)
}


#' Extract all canvas from a Figma Document
#'
#' Collect all canvas objects present in a Figma Document object.
#'
#' @param document a Figma Document (i.e. a object of class `figma_document`);
extract_canvas <- function(document){
  list_of_canvas <- document$content$children
}
