test_that("`get_endpoint_url()`: Selects just a single Figma endpoint", {
  expect_length(get_endpoint_url("files"), 1L)
})


test_that("`get_endpoint_url()`: Expect an error when selecting a non-available endpoint", {
  expect_error(get_endpoint_url("weird_endpoint"))
})


test_that("`get_endpoint_url()`: Expect an error when using a vector of endpoints", {
  expect_error(get_endpoint_url(c("a", "b", "c")))
})





