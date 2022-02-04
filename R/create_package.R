#' Create template files in package in cwd
#'
#' @description Populate the necessary template files in the package
#'  that is at the current working directory.
#'
#' @details
#' For RStudio to recognize a package as suitable for a
#' markdown template, there are several files/directories that are needed. This function will create the
#' package and then populate the necessary information based on `tmpl`. Note
#' that there remains some work to do with the package, not everything in life is
#' free! Some things to consider tweaking are the DESCRIPTION (this is not modified)
#' and the actual template.yaml file used in RStudio.
#'
#' @note There are functions \code{\link[usethis]{use_rmarkdown_template}} and
#' \code{\link[usethis]{use_template}} that should be
#' used as the implementation here.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param banner A image file to use as banner (see \code{\link{use_banner}}).
#' @param from Source package, defaults to `dsreportr::ds_pdf`.
#' @return Nothing, but the files will be populated in the existing package.
#' @export
#'
#' @examples
#' \dontrun{create_template_in_package("bbireportr::bbi_pdf")}
create_template_in_package<-function(tmpl,
                                     banner = NULL,
                                     from = "dsreportr::ds_pdf"
                                     ) {

  src <- identify_template(from)
  tgt <- identify_template(tmpl)

  cli::cli_alert_info("Creating template code in {here::here()} from {from}.")

  cli::cli_alert_info("Creating wrapper function.")
  create_wrapper_function(tmpl, from)

  # Create template directory
  cli::cli_alert_info("Creating template directory.")
  tmpl_dir <- find_template_dir(tmpl)

  dir.create(tmpl_dir, recursive=TRUE) ||
    cli::cli_abort("Could not create template directory {tmpl_dir}.")
  cli::cli_alert_success("Created template directory {tmpl_dir}.")

  cli::cli_alert_info("Creating skeleton markdown.")
  create_skeleton_markdown(tmpl)

  if (!is.null(banner))
    use_banner(tmpl, banner)

  cli::cli_alert_info("Creating yml description.")
  create_yml_description(tmpl)
}

#' Create a default YML description file
#'
#' @description A YML description file `template.yaml` is needed to have RStudio
#' recognize the package as a template. This function performs that task.
#'
#' @details
#' See \code{\link{create_template_in_package}} for details.
#'
#' @note This is an internal package function, not for global consumption.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param name Name of the template (defaults to the tmpl name)
#' @param description Description of the template (defaults to A template for name based on dsreportr).
#' @param create_dir Should a new markdown file involve a new directory (defaults to FALSE)
#'
#' @return Nothing is return
#'
#' @examples
#' \dontrun{
#' create_yml_description("bbireportr::bbi_pdf")}
create_yml_description <- function(tmpl,
                                   name = identify_template(tmpl)$template,
                                   description=glue::glue("A template for {name} based on dsreportr."),
                                   create_dir=FALSE) {
  yml_text <- glue::glue("name: {name}\ndescription: {description}\ncreate_dir: {create_dir}\n" )
  yml_file <- file.path(find_template_dir(tmpl), "template.yaml")
  readr::write_file(yml_text, file = yml_file)

  message(sprintf("Created yml file %s.",yml_file))

}


#' Create skeleton markdown template file
#'
#' This function will copy over the dsreportr template skeleton file and
#' modify a few variables for it's use in the new template.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#'
#' @return Nothing, but skeleton created.
#' @note This is an internal package function, not for global consumption.
#' @importFrom rlang .data
create_skeleton_markdown <- function(tmpl) {
  skeleton_dir <- find_skeleton_dir(tmpl)
  skeleton_file <- find_skeleton_file(tmpl)

  # Create the skeleton markdown, this will crash on error.
  dir.create(skeleton_dir) ||
    stop(sprintf("Could not create %s.",skeleton_dir))
  new_markdown(name = skeleton_file)
  message(sprintf("Created %s.",skeleton_file))

  # Modify the skeleton file in a few key places.
  md <- readr::read_file(skeleton_file) %>%
          stringr::str_replace_all("dsreportr::ds_pdf", tmpl)

  readr::write_file(md, file = skeleton_file)

  message(sprintf("Patched %s with %s information.", skeleton_file, tmpl))

}

#' Create the wrapper pdfdocument function
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param from A template of the form `pkg::template_pdf`.
#'
#' @return Nothing, but the wrapper function is created.
#'
create_wrapper_function <- function(tmpl, from) {

  src<-identify_template(from)
  template <- identify_template(tmpl)$template

  m<-"#'"
  # Wrapper function
  wrapper_function_text <- glue::glue("
{m} Rmarkdown {template} template function
{m}
{m} See \\code{{\\link[{src$package}]{{{src$template}}}} for details.
{m}
{m} @param ... Parameters to pass to pdf_document2().
{m}
{m} @export
{template} <- function(...) {from}(...)
  ")

  # Write the output to the appropriate R script.
  r_script <- file.path(find_R_dir(), paste0(template,".R"))
  readr::write_file(wrapper_function_text, file = r_script)

  cli::cli_alert_success("Created wrapper function {r_script}.")

}


#' Use image as banner image in template
#'
#' @description For a dsreportr derived template, an image can
#' be used as a banner. This will install an image in a package
#' directory, assuming the working directory is in the package
#' directory structure.
#'
#' @details
#' The template structure allows for a banner to be used within
#' a template. This function is inspired by the `usethis` package,
#' to "install" the image file into the appropriate location within
#' a package.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param img A filename of an image to use as a banner.
#'
#' @export
#'
#' @examples
#' \dontrun{use_banner("dsreportr::ds1_pdf", "image.png")}
use_banner <- function(tmpl, img) {
  checkmate::assert_file_exists(img, access="r")
  checkmate::assert_string(img, pattern = "\\.(png|jpg)")
  # Copy img to package directory
  img_dir <- file.path(find_template_dir(tmpl), "resources")
  checkmate::test_directory_exists(img_dir, access="w") ||
    dir.create(img_dir, showWarnings=FALSE)
  banner_image <- file.path(
    img_dir,
    sprintf("%s.%s", identify_template(tmpl)$template, tools::file_ext(img))
  )
  file.copy(img, banner_image)
  checkmate::test_file_exists(banner_image, access="r")

  # Fix skeleton file
  skeleton_file <- find_skeleton_file(tmpl)
  md <- readr::read_file(skeleton_file) %>%
            stringr::str_replace_all(
              "banner: \"\`r dsreportr::banner\\(\\)\`\"",
              glue::glue("banner: \"\`r dsreportr::banner\\('{tmpl}'\\)\`\"")
            ) %>%
            readr::write_file(file = skeleton_file)

  cli::cli_alert_success(sprintf("Patched %s to use %s.",skeleton_file,
                                 basename(img)))


}

find_skeleton_dir <- function(tmpl) {
  file.path(find_template_dir(tmpl), "skeleton")
}
find_skeleton_file <- function(tmpl) {
  file.path(find_skeleton_dir(tmpl), "skeleton.Rmd")
}
find_template_dir <- function(tmpl) {
  src <- identify_template(tmpl)
  file.path(find_pkg_dir(), "inst","rmarkdown","templates", src$template)
}
find_pkg_dir <- function() {
  here::here()
}
find_R_dir <- function(tmpl) {
  file.path(find_pkg_dir(), "R")
}
