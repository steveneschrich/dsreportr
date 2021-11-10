

#' Identify pkg and template from a pkg::template string
#'
#' @param s A string of the form pkg::template
#'
#' @return A list of package and template strings, representing the input.
#'
#' @export
#' @examples
#' identify_template("dsreportr::ds_pdf")
#'
identify_template<-function(s) {
  chunks <- strsplit(s, "::")[[1]]
  stopifnot("Input template not specified correctly. It should be in the form of
pkg::template, e.g. dsreportr::ds_pdf." = length(chunks)==2)
  list(package=chunks[[1]], template=chunks[[2]])
}
