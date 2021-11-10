
#' Create package for templates.
#'
#' @description This function will create a new package (called `tmpl`) in
#' the current directory, then populate the necessary components to be a
#' R template package.
#'
#' @details
#' For RStudio to recognize a package as suitable for a markdown template, there
#' are several files/directories that are needed. This function will create the
#' package and then populate the necessary information based on `tmpl`. Note
#' that there remains some work to do with the package, not everything in life is
#' free! Some things to consider tweaking are the DESCRIPTION (this is not modified)
#' and the actual template.yaml file used in RStudio.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param from Source package, defaults to `dsreportr::ds_pdf`.
#'
#' @return Nothing is returned, but a package should be created.
#' @export
#'
#' @examples
#' \dontrun{create_package("bbireportr::bbi_pdf")}
#'
create_package<-function(tmpl, from = "dsreportr::ds_pdf") {
  usethis::create_package(identify_template(tmpl)$package, rstudio=FALSE, open = FALSE)
  create_template_in_package(tmpl, from)
}

#' Create template files in package in cwd
#'
#' @description Populate the necessary template files in the package
#'  that is at the current working directory.
#'
#' @details
#' There are a few files/directories needed to make RStudio recognize a package as
#' templates. This does the work. See \code{\link{create_package}} for details.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param from Source package, defaults to `dsreportr::ds_pdf`.
#'
#' @return Nothing, but the files will be populated in the existing package.
#' @export
#'
#' @examples
#' \dontrun{create_template_in_package("bbireportr::bbi_pdf")}
create_template_in_package<-function(tmpl, from="dsreportr::ds_pdf") {

  src <- identify_template(from)
  tgt <- identify_template(tmpl)

  cli::cli_alert_info("Creating template code in {here::here()} from {from}.")

  cli::cli_alert_info("Creating wrapper function.")
  create_wrapper_function(tmpl, from)

  # Create template directory
  cli::cli_alert_info("Creating template directory.")
    tmpl_dir <- file.path(here::here(), "inst","rmarkdown","templates",tgt$template)
  dir.create(tmpl_dir, recursive=TRUE) ||
    cli::cli_abort("Could not create template directory {tmpl_dir}.")
  cli::cli_alert_success("Created template directory {tmpl_dir}.")

  cli::cli_alert_info("Creating skeleton markdown.")
  create_skeleton_markdown(tmpl, file.path(tmpl_dir,"skeleton"), banner=TRUE)

  cli::cli_alert_info("Creating yml description.")
  create_yml_description( tmpl, tmpl_dir)
}

#' Create a default YML description file
#'
#' @description A YML description file `template.yaml` is needed to have RStudio
#' recognize the package as a template. This function performs that task.
#'
#' @details
#' See \code{\link{create_package}} for details.
#'
#' @note This is an internal package function, not for global consumption.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param tmpl_dir Template directory
#' @param name Name of the template (defaults to the tmpl name)
#' @param description Description of the template (defaults to A template for name based on dsreportr).
#' @param create_dir Should a new markdown file involve a new directory (defaults to FALSE)
#'
#' @return Nothing is return
#'
#' @examples
#' \dontrun{
#' create_yml_description("bbireportr::bbi_pdf", "some/dir/structure")}
create_yml_description <- function(tmpl, tmpl_dir,
                                   name = identify_template(tmpl)$template,
                                   description=glue::glue("A template for {name} based on dsreportr."),
                                   create_dir=FALSE) {

  yml_text <- glue::glue("name: {name}\ndescription: {description}\ncreate_dir: {create_dir}\n" )
  yml_file <- glue::glue("{tmpl_dir}/template.yaml")
  readr::write_file(yml_text, file = yml_file)

  cli::cli_alert_success("Created yml file {yml_file}.")

}


#' Create skeleton markdown template file
#'
#' This function will copy over the dsreportr template skeleton file and
#' modify a few variables for it's use in the new template.
#'
#' @param tmpl A template of the form `pkg::template_pdf`.
#' @param skeleton_dir Skeleton template directory
#' @param banner Should banner be included (default FALSE)
#'
#' @return Nothing, but skeleton created.
#' @note This is an internal package function, not for global consumption.
#' @importFrom rlang .data
create_skeleton_markdown <- function(tmpl, skeleton_dir, banner = FALSE) {
  skeleton_file <- file.path(skeleton_dir,"skeleton.Rmd")

  # Create the skeleton markdown, this will crash on error.
  dir.create(skeleton_dir) ||
    cli::cli_abort("Could not create {skeleton_dir}.")
  new_markdown(name = skeleton_file)
  cli::cli_alert_success("Created {skeleton_file}.")

  # Modify the skeleton file in a few key places.
  md <- readr::read_file(skeleton_file) %>%
          stringr::str_replace("dsreportr::ds_pdf", tmpl) %>%
          stringr::str_replace("dsreportr::banner()",
              glue::glue("dsreportr::banner({ifelse(banner, tmpl, '')})"))


  readr::write_file(md, file = skeleton_file)

  cli::cli_alert_success("Patched {skeleton_file} with {tmpl} information.")

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
  tgt <- identify_template(tmpl)

  m<-"#'"
  # Wrapper function
  wrapper_function_text <- glue::glue("
{m} Rmarkdown {tgt$template} template function
{m}
{m} See \\code{{\\link[{tgt$package}]{{{tgt$template}}}} for details.
{m}
{m} @param ... Parameters to pass to pdf_document2().
{m}
{m} @export
{tgt$template} <- function(...) {from}(...)
  ")

  # Write the output to the appropriate R script.
  r_script <- file.path(here::here(), "R", paste0(tgt$template,".R"))
  readr::write_file(wrapper_function_text, file = r_script)

  cli::cli_alert_success("Created wrapper function {r_script}.")

}

