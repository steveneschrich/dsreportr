#' Return path to template banner image
#'
#' @description Each template can have a banner image to show on the
#' first page of the report. This function returns the path to that
#' banner.
#'
#' @note If there are multiple banner.png/banner.jpg etc files, then
#' the first such file is returned.
#'
#' @param tmpl A string representing a rmarkdown template, with the package
#' prefix. For example, "dsreportr::ds_pdf".
#' @param img_regex A string representing a regular expression that identifies
#'   the expected image type.
#' @return A path to a banner image.
#' @export
#'
#' @examples
#' banner("ds_reportr::ds_pdf")
banner <- function(tmpl="dsreportr::ds_pdf", img_regex="*banner.png|*banner.jpg") {
  tmpl <- identify_template(tmpl)
  resource_dir <- system.file(file.path("rmarkdown","templates",tmpl$template),
                   "resources",
                   package = tmpl$package)
  img_files<-list.files(path = resource_dir, pattern = img_regex,
                        ignore.case=TRUE,
                        full.names=TRUE
              )

  img_files[1]

}
