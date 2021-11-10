test_that("default template location ok", {
  expect_equal(identify_template("dsreportr::ds_pdf"),
               list(package="dsreportr",template = "ds_pdf"))
  expect_error(identify_template("dsreportr"))
})
