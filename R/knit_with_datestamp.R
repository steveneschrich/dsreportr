#' Knit a document with datestamp appended to output file
#'
#' @description Using rmarkdown::render to generate an output file from a markdown file.
#' This function includes a datestamp on the filename to make it unique (by day).
#'
#' @details Generating output from markdown document overwrites the existing output file.
#' Source markdown can be versioned, but it would be convenient to also store multiple copies
#' of a report. This function appends a date stamp (YYYY-MM-DD) to the output file so
#' reports can change over time. Ideally, this would follow the versioning in git but that
#' has not been implemented yet.
#'
#' @note Knitr needs the yml header to be simple (or extra syntax is required), so this
#' function is designed to operate without specifying parameters in the yml.
#'
#' @param input The input file to knit
#' @param output_dir An output directory to store results (default is project roo/delivery)
#' @param ... Other parameters to pass to rmarkdown::render
#'
#' @return rmarkdown::render return result
#' @export
#'
#' @examples
#' \dontrun{
#' knit_with_datestamp
#' }
knit_with_datestamp <- function(input, output_dir = "delivery", ...) {
  rmarkdown::render(
    input,
    output_dir = here::here(output_dir),
    output_file = paste0(
      xfun::sans_ext(input), '_',
      format(Sys.time(), "%Y-%m-%d")
    ),
    envir = globalenv()
  )
}
