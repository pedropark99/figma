
api_base_url <- "https://api.figma.com"
api_endpoints <- list(
  files = "/v1/files/"
)


concat_urls <- function(...){
  components <- list(...)
  components <- as.character(components)
  url <- paste(components, collapse = "/")
  return(url)
}


get_files_url <- function(){
  url <- paste0(
    api_base_url, api_endpoints$files,
    collapse = ""
  )

  return(url)
}
