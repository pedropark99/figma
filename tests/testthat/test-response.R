test_that("`select_any_of()`: If none elements are found, return an empty list", {
  l <- list(a = 1, b = 2, c = 3, d = 4)
  selected <- select_any_of(l, c("e", "f", "g"))
  empty_list <- list()
  names(empty_list) <- character()
  expect_equal(selected, empty_list)
})



test_that("`parse_response_object()`: Expect error when we use an object of class != 'response'", {
  a_list <- list()
  a_vector <- character()

  expect_error(parse_response_object(a_list))
  expect_error(parse_response_object(a_vector))
})


test_that("`as_figma_document()`: Expect no warnings or messages while converting object", {

  expect_no_warning(as_figma_document(quarto_website))
  expect_no_warning(as_figma_document(untitled_file))

  expect_no_message(as_figma_document(quarto_website))
  expect_no_message(as_figma_document(untitled_file))
})




test_that("`as_tibble()`: Expect no warnings or messages while converting object", {

  expect_no_warning(figma::as_tibble(quarto_website))
  expect_no_warning(figma::as_tibble(untitled_file))

  expect_no_message(figma::as_tibble(quarto_website))
  expect_no_message(figma::as_tibble(untitled_file))
})
