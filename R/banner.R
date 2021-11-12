#' Return path to template banner image
#'
#' @description Each template can have a banner image to show on the
#' first page of the report. This function returns the path to that
#' banner.
#'
#' @note If there are multiple .png/.jpg etc files, then
#' the first such file is returned.
#'
#' @param tmpl A string representing a rmarkdown template, with the package
#' prefix. For example, `dsreportr::ds_pdf`.
#' @param img_extensions A list of image extensions to look for (default is `c("png","jpg")`).
#' @return A path to a banner image.
#' @export
#'
#' @examples
#' \dontrun{
#' banner("ds_reportr::ds_pdf")
#' }
banner <- function(tmpl="dsreportr::ds_pdf", img_extensions=c("png","jpg")) {
  tmpl <- identify_template(tmpl)
  img_regex <- glue::glue("{tmpl$template}\\.({paste(img_extensions, collapse='|')})")
  resource_dir <- system.file(file.path("rmarkdown","templates",tmpl$template),
                   "resources",
                   package = tmpl$package)
  img_files<-list.files(path = resource_dir, pattern = img_regex,
                        ignore.case=TRUE,
                        full.names=TRUE
              )
  checkmate::assert_vector(img_files, min.len=1)

  img_files[1]

}
