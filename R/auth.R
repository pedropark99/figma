

token <- function(token){
  env <- new.env()
  env$token <- token
  return(env)
}


build_auth_header <- function(token){
  httr::add_headers("X-Figma-Token" = token)
}
