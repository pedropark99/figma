#' Parse the response object returned by Figma API
#'
#'

response_content <- function(response){
  httr::content(response, encoding = "UTF-8")
}


as_figma_document <- function(response){
  content <- response_content(response)$document
  n_canvas <- length(content$children)
  n_nodes <- purrr::map_int(content$children, length)
  names(n_nodes) <- paste("Canvas", seq_along(content$children))
  structure(
    list(name = "Figma Document", content = content,
         n_canvas = n_canvas, n_nodes = n_nodes),
    class = "figma_document"
  )
}


print.figma_document <- function(x, ...){
  cat("<Figma Document>", "\n\n", sep = "")
  cat(" * Number of canvas:", x$n_canvas, "\n")
  cat(" * Number of nodes:", str(x$n_nodes), "\n")
  invisible(x)
}

as_canvas <- function(content){
  list_of_canvas <- content$document$children
}
