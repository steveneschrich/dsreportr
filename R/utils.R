

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


#' List available templates within a package.
#'
#' @description Templates are defined using a particular structure (for RStudio). This
#' function lists the available templates from a named package.
#'
#' @details Templates are defined by a couple of key files in particular locations within
#' a package. One notable file is the `template.yaml` file which provides a name and
#' description of the template.
#'
#' This function looks in the package and reports on all templates that have a `template.yaml`
#' file in the `rmarkdown/templates` directory. It reports on the template name, pretty name
#' and description.
#'
#' @note This function is vectorized, so pkg can be a vector of packages.
#'
#' @param pkg A package to enumerate templates within.
#'
#' @return A simple \code{\link[knitr]{kable}} representing the available templates.
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#' list_template("dsreportr")
#' ## template   name                              description
#' ## ---------  --------------------------------  ------------------------------------
#' ## ds_docx    Data Science DOCX Report Output   A Generic Data Science DOCX report.
#' ## ds_pdf     Data Science PDF Report Output    A Generic Data Science PDF report.
#'
#'
#' list_template(c("dsreportr","qsctemplates"))
#' ## template   name                              description
#' ## ---------  --------------------------------  -------------------------------------------------
#' ## ds_docx    Data Science DOCX Report Output   A Generic Data Science DOCX report.
#' ## ds_pdf     Data Science PDF Report Output    A Generic Data Science PDF report.
#' ## qsc_pdf    QSC PDF Template                  A template for the U54 QSC based on dsreportr.
#' ## u54_pdf    U54 PDF Report Template           A template for U54 reporting (not QSC specific).
#' }
list_templates<-function(pkg) {
  purrr::map_chr(pkg, ~fs::path_package(., "rmarkdown","templates")) %>%
  fs::dir_ls(type = "dir") %>%
    purrr::map_dfr(fs::path(template_info, "template.yaml")) %>%
    knitr::kable(format="simple")

}



#' Extract template information from a template.
#'
#' @description A template is defined in part by a YAML file containing template
#' details. This function extracts the contents of the YAML and returns in a tibble.
#'
#' @param f A path to a `template.yaml` file.
#'
#' @return A data frame with template information.
#' @export
#'
#' @importFrom dplyr %>%
#' @examples
#' \dontrun{
#' template_info("/path/to/pkg/rmarkdown/templates/pkg/template.yaml")
#'
#' ## # A tibble: 1 × 3
#' ##     template name                            description
#' ##     <chr>    <chr>                           <chr>
#' ## 1   ds_docx  Data Science DOCX Report Output A Generic Data Science DOCX report.
#'
#' }
template_info <- function(f) {
   if ( ! fs::file_access(f) ) return()

  readr::read_delim(f,
                    delim=": ", col_types ="ccc", col_names = c("variable","value")) %>%
      tidyr::pivot_wider(names_from="variable", values_from = "value") %>%
      dplyr::mutate(template = fs::path_file(fs::path_dir(f))) %>%
      dplyr::select(.data$template, .data$name, .data$description)

}
