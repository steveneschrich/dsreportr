#' Create markdown file based on existing template.
#'
#' @description Markdown templates have skeleton markdown files that can
#' be used to start a report. This function creates a markdown file based
#' on that template.
#'
#'
#' @param tmpl A string representing a rmarkdown template, with the package
#' prefix. For example, "dsreportr::ds_pdf".
#' @param name A filename to write out the markdown to (default is Untitled.Rmd).
#'
#' @return Logical value indicating success/failure of the file copy operation (
#' see \code{\link[base]{file.copy}}).
#'
#' @export
#'
#' @examples
#' \dontrun{new_markdown("dsreportr::ds_pdf")}
#'
new_markdown<-function(tmpl="dsreportr::ds_pdf", name="Untitled.Rmd") {
  tmpl <- identify_template(tmpl)
  if (file.exists(name)) {
    orig_name <- name
    name <- sprintf("Untitled_%s.Rmd", format(Sys.time(), '%Y%m%d'))
    cli::cli_alert_warning("{orig_name} already exists, using {name} instead.")
  }
  # Now find the file
  f <- system.file(file.path("rmarkdown","templates",tmpl$template,"skeleton"),
              "skeleton.Rmd",
              package = tmpl$package)
  # And copy f to name.
  file.copy(f, name) ||
    cli::cli_abort("Could not copy {f} to {name}.")

  cli::cli_alert_success("Copied {f} to {name} successfully.")

  TRUE
}
