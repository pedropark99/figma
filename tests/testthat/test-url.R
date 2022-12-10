# Unit tests for `get_endpoint_url()` --------------------------------

test_that("`get_endpoint_url()`: Selects just a single Figma endpoint", {
  expect_length(get_endpoint_url("files"), 1L)
})

test_that("`get_endpoint_url()`: Expect an error when selecting a non-available endpoint", {
  expect_error(get_endpoint_url("weird_endpoint"))
})

test_that("`get_endpoint_url()`: Expect an error when using a vector of endpoints", {
  expect_error(get_endpoint_url(c("a", "b", "c")))
})

test_that("`get_endpoint_url()`: Expect an error when using NA or NULL values", {
  expect_error(get_endpoint_url(NA_character_))
  expect_error(get_endpoint_url(NULL))
})





# Unit tests for `build_request_url()` -------------------------------

test_that("build_request_url(): Expect a error when using a vector in `base_url` argument", {
  expect_error(build_request_url(c("a", "b", "c")))
})

test_that("build_request_url(): Expect a error when using NULL or NA in `base_url` argument", {
  expect_error(build_request_url(NULL))
  expect_error(build_request_url(NA_character_))
})

test_that("build_request_url(): Expect a error when using a named argument with `NULL` or `NA` value", {
  expect_error(build_request_url("base-url", test_null = NULL))
  expect_error(build_request_url("base-url", test_na = NA))
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

  expect_single_string(build_request_url("base-url"))

  expect_single_string(build_request_url("base-url", c(NA, NA)))
})


test_that("build_request_url(): Expect error when using unnamed arguments in `...`", {
  expect_error(build_request_url(
    base_url = "base-url", path = "a-path",
    # unnamed arguments:
    NA, 0, NULL, "test"))
})

test_that("build_request_url(): Expect error when using any argument in `...` with NULL or NA values", {
  expect_error(build_request_url(
    base_url = "base-url", path = "a-path", skip = 100,
    # arguments with NULL or NA
    na_value = NA))


  expect_error(build_request_url(
    base_url = "base-url", path = "a-path", skip = 100,
    # arguments with NULL or NA
    null_value = NULL))
})








# Unit tests for `build_query_string()` ---------------------------------

test_that("`build_query_string()`: Expect an error with no inputs", {
  expect_error(build_query_string())
})

test_that("`build_query_string()`: Expect error when using unnamed elements in input list", {
  expect_error(build_query_string(list(1)))
})

test_that("`build_query_string()`: Always output a single string", {
  expect_single_string(build_query_string(list(skip = 100, info = FALSE, data = "students")))

  expect_single_string(build_query_string(list(skip = 100)))
})


