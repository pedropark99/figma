#' Get a Figma File from the API
#'
#' Use the \code{/v1/files/} endpoint of Figma API to get a Figma File as an R object.
#'
#'
#' You can easily get the key of your Figma File from the URL of this file.
#' In other words, when you visit this file in your web browser, the URL
#' will probably look something like this:
#'
#' \code{https://www.figma.com/file/hch8YlkIrYbU3raDzjPvCz/Untitled}
#'
#' In the above example, the string \code{hch8YlkIrYbU3raDzjPvCz} is the
#' key to the file. So, every URL to a Figma File comes in the following format:
#'
#' \code{https://www.figma.com/file/file_key/file_title}
#'
#' @param file_key A string with the key of the Figma File you want to get;
#' @param token A string with your personal Figma token to authenticate in the API;
#'
#' @returns A Figma Document object (i.e. a object of class `figma_document`);
get_figma_file <- function(file_key, token){
  url <- get_files_url()
  url <- paste0(
    url,
    file_key,
    collapse = ""
  )
  header <- httr::add_headers(
    "X-Figma-Token" = token
  )
  r <- httr::GET(url = url, header)
  return(as_figma_document(r))
}



