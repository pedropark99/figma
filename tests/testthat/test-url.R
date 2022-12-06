test_that("`get_endpoint_url()`: Selects just a single Figma endpoint", {
  expect_length(get_endpoint_url("files"), 1L)
})


test_that("`get_endpoint_url()`: Expect an error when selecting a non-available endpoint", {
  expect_error(get_endpoint_url("weird_endpoint"))
})


test_that("`get_endpoint_url()`: Expect an error when using a vector of endpoints", {
  expect_error(get_endpoint_url(c("a", "b", "c")))
})







test_that("build_request_url(): Expect a error when using a vector in `base_url` argument", {
  expect_error(build_request_url(c("a", "b", "c")))
})

test_that("build_request_url(): Expect a error when using NULL or NA in `base_url` argument", {
  expect_error(build_request_url(NULL))
})

test_that("build_request_url(): Expect a error when using NULL or NA in `base_url` argument", {
  expect_error(build_request_url(NA_character_))
})

test_that("build_request_url(): Expect a error when using a named argument with NULL", {
  expect_error(build_request_url("base-url", test = NA, test2 = NULL))
})


expect_single_string <- function(object){
  act <- quasi_label(rlang::enquo(object), arg = "object")

  condition <- length(act$val) == 1 &&
    is.character(act$val) &&
    !is.na(act$val) && !is.null(act$val)
  if (condition) {
    succeed()
    return(invisible(act$val))
  }

  message <- sprintf("%s is not a single string!", act$lab)
  fail(message)
}

test_that("build_request_url(): Should always output a single string value", {
  expect_single_string(build_request_url(
    "base-url",
    c(NA, NA, NA, 'hgf'),
    test = 'abc', test2 = '890', lazy = 'mooorelazy'))
})


test_that("build_request_url(): Should always output a single string value", {
  expect_single_string(build_request_url("base-url"))
})

test_that("build_request_url(): Should always output a single string value", {
  expect_single_string(build_request_url("base-url", c(NA, NA)))
})


