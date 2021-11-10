#' Generate PDF based on Generic Data Science Template
#'
#' @description This function will apply the ds template to rmarkdown
#' to generate a ds-styled pdf output file.
#'
#' @details
#' This function is called after knitr completes once the rmarkdown is to be
#' converted to a article pdf. This is achieved by setting the output type
#' in the YAML to be `ds_pdf` output.
#'
#' Currently, a master latex article template is used (based on the pandoc
#' default template) with some local customizations. They are consistent across
#' templates in this package so is a general output. Additionally some customized
#' YAML entries allow the latex article template to look as expected so it is
#' currently included as a master template.
#'
#' Finally, there is a template-specific logo that is included for each template.
#' The trick with this is the logo is in a directory that can't be easily known
#' based on where the package was installed. utils.R in this package contains
#' necessary code to find the template or the resource (logo).
#'
#' One additional parameter of note is the keep_tex=YES flag. This is useful
#' for debugging since one can see the latex after replacements, etc. It
#' should usually be FALSE to keep things tidy.
#'
#' @param latex_engine The default latex engine, which should be pdflatex
#' @param fig_caption Use figure captions
#' @param template Latex template file (default is ds_pdf.tex).
#' @param ... Other parameters to pass to pdf_document2().
#'
#' @return A compiled pdf.
#' @export
ds_pdf <- function(...,
                    latex_engine = "pdflatex",
                    fig_caption = TRUE,
                    template = latex_template()
) {



  # This is the only call I actually need, everything else in the
  # YAML.
  bookdown::pdf_document2(template = template, ...)

}
