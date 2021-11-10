#' Return path to latex template file
#'
#' @description This returns the path to the latex template file that can
#' used in this package or other packages that derive from it.
#'
#' @return A path to a template latex file, suitable for using in rmarkdown
#' reports.
#' @export
#'
#' @examples
#' latex_template()
#'
latex_template <- function() {
  system.file(file.path("rmarkdown","templates","ds_pdf","templates"),
              "ds_pdf.tex",
              package = "dsreportr")
}
