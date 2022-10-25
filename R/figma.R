


figma_file <- function(file_key, token){
  url <- get_files_url()
  url <- paste0(
    url,
    file_key,
    collapse = ""
  )
  header <- httr::add_headers(
    "X-Figma-Token" = token
  )
  httr::GET(url = url, header)
}
