#' Return path to template docx
#'
#' @description Word templates have a template docx file that markdown starts
#' from for the report. This function returns the path to that word template.
#'
#'
#' @param tmpl A string representing a rmarkdown template, with the package
#' prefix. For example, `dsreportr::ds_docx`.
#'
#' @return A path to a word template docx.
#' @export
#'
#' @examples
#' \dontrun{
#' docx_template("ds_reportr::ds_docx")
#' }
docx_template <- function(tmpl="dsreportr::ds_docx") {
  tmpl <- identify_template(tmpl)
  docx_file <- glue::glue("{tmpl$template}.docx")
  docx_template <- system.file("rmarkdown","templates", tmpl$template, "resources", docx_file,
                              package = tmpl$package)
  checkmate::assert_file_exists(docx_template)

  docx_template

}

#' Return docx template as officer object
#'
#' @description Word templates have a template docx file that can be used to start interacting
#' with the `officer` package. This function returns a template object.
#'
#'
#' @param tmpl A string representing a rmarkdown template, with the package
#' prefix. For example, `dsreportr::ds_docx`.
#'
#' @return A docx object for use with officer
#' @export
#'
#' @examples
#' \dontrun{
#' docx("ds_reportr::ds_docx")
#' }
docx <- function(tmpl = "dsreportr::ds_docx") {
  officer::read_docx(docx_template(tmpl))
}
