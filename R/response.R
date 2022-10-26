#' Parse the response object returned by Figma API
#'
#'

response_content <- function(response){
  httr::content(response, encoding = "UTF-8")
}


parse_response_object <- function(response, .output_format){
  check_for_http_errors(response)
  output_format <- check_output_format(.output_format)
  if (output_format == 'response') {
    return(response)
  }
  if (output_format == 'figma') {
    return(as_figma_document(response))
  }
}

check_for_http_errors <- function(response){
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
    "* URL used in the request: ", response$url, "\n",
    sep = "", file = stderr()
  )
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

#' Convert a `httr` response object to a Figma Document object
#'
#' This function is not intended for client/user-use.
#'
#' @param response a `response` object produced by a `httr` HTTP method (e.g. `httr::GET()`, `httr::POST()`, etc.);
as_figma_document <- function(response){
  if (!inherits(response, "response")) {
    stop("Object is not of type `response`!")
  }
  content <- httr::content(a)
  document <- content$document[c("id", "name", "type")]
  canvas <- content$document[["children"]]
  n_nodes <- purrr::map_int(canvas, length)
  names(n_nodes) <- paste("Canvas", seq_along(canvas))
  structure(
    list(name = "Figma Document", document = document,
         canvas = canvas, n_canvas = length(canvas),
         n_nodes = n_nodes),
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


as_tibble <- function(response){
  data <- as_figma_document(response)
  data$canvas
}

#' Extract all canvas from a Figma Document
#'
#' Collect all canvas objects present in a Figma Document object.
#'
#' @param document a Figma Document (i.e. a object of class `figma_document`);
extract_canvas <- function(document){
  list_of_canvas <- document$content$children
}
