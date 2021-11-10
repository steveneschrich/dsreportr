#' Return R runtime environment
#'
#' @description Provide R runtime environment as a tibble
#'
#' @details
#' For markdown templates, it is convenient to print out the environment
#' during the execution. This includes username, platform, R version,
#' etc. Most of this exists in \code{\link[utils]{sessionInfo}},
#' \code{\link[sessioninfo]{platform_info}},
#' \code{]link[whoami]{username}}. This function simply ties the information
#' together in a single table for output.
#'
#' @note This function returns a table, the corresponding
#' \code{\link{style_environment_information_as_kable}} or
#' \code{\link{style_environment_information_as_flextable}}
#' outputs it for knitting.
#'
#' @return The \code{\link[tibble]{tibble}} representing environmental variables.
#' @export
#'
#' @importFrom magrittr %>%
#' @examples
#' get_environment_information()
#'
get_environment_information<-function() {

  # We define custom information we want to see.
  tibble::tribble(
    ~setting, ~value,
    "username", whoami::username(),
    "user", whoami::fullname(),
    "file", ifelse(is.null(knitr::current_input()),
                   "No Input File Detected.",
                   knitr::current_input()
    ),
    "git", ifelse(git2r::in_repository(),
                  git2r::remote_url(),
                  "Git not configured for project."
    ),
    "dir", getwd(),
    "hostname", Sys.info()[["nodename"]]
  ) %>%
    # And then include the default information from devtools.
    dplyr::bind_rows(
      tibble::enframe(
        unlist(sessioninfo::platform_info()),
        name = "setting",
        value = "value"
      )
    )


}

#' Style environment information as kable output.
#'
#' @description
#' This function styles the output of an environment table suitable
#' for inclusion in a markdown report.
#'
#' @param tbl A tibble of environment information (see
#' \code{\link{get_environment_information}}).
#'
#' @return A \code{\link[knitr]{kable}} styled for output.
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @examples
#'
#' style_environment_information_as_kable(get_environment_information())
#'
style_environment_information_as_kable<-function(tbl) {
  tbl %>%
    knitr::kable(
      caption = "Supplemental Table: Environment Information",
      label = "Supplemental-Environment-Information",
      booktabs = TRUE
    ) %>%
    kableExtra::kable_styling(latex_options=c("hold_position"))

}

#' Style environment information as flextable output.
#'
#' @param tbl A tibble of environment information (see
#'  \code{\link{get_environment_information}}).
#'
#' @return A \code{\link[flextable]{flextable}} styled for output.
#' @export
#'
#' @examples
#' style_environment_information_as_flextable(get_environment_information())
style_environment_information_as_flextable<-function(tbl) {

  tbl %>%
    flextable::flextable() %>%
    flextable::set_caption("Supplemental Table: Environment Information") %>%
    flextable::theme_booktabs()
}





#' Retrieve package information.
#'
#'
#' @return A tibble representing package information.
#'
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
#'
get_package_information<-function() {

  # Get package info from sessioninfo, then manipulate it like sessioninfo
  # does, but leave it in a tibble (as opposed to sessioninfo which then
  # cats it). Code from sessioninfo.
  tibble::as_tibble(sessioninfo::package_info()) %>%
    dplyr::mutate(
      unloaded = is.na(.data$loadedversion),
      `*`=ifelse(.data$attached, "*",""),
      `lib` = encode_library(.data$library),
      version = ifelse(.data$unloaded, .data$ondiskversion, .data$loadedversion)
    )
}

#' Encode library string as index
#'
#' @description The library in sessioninfo is a path, but as a factor. This
#' translates to numeric index.
#'
#' @details The sessioninfo library provides code for translating a library
#' string into its index so it can be printed succinctly. This duplicates that
#' mostly unavailable code for use here.
#'
#' @param l A list of library entries (some of which may be NA)
#'
#' @return A encoded library list (the index of the factor).
#'
encode_library<-function(l) {
  sprintf("[%s]", ifelse(is.na(l), "?", as.integer(l)) )
}


#' Style package information as knitr kable.
#'
#' @description Provide a \code{\link[knitr]{kable}} formatted output
#' for the package information.
#'
#'
#' @param packages The packages tibble from
#'    \code{\link[sessioninfo]{session_info}}
#'
#' @return Kable-formatted package information.
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examples
#' style_package_information_as_kable(get_package_information())
#'
style_package_information_as_kable<-function(packages) {

  packages %>%
    dplyr::select(.data$package, .data$`*`, .data$version,
                  .data$date, .data$lib, .data$source) %>%
    knitr::kable(
      booktabs = TRUE,
      longtable = TRUE,
      caption = "Supplemental Table: Package Version Information",
      label = "ff"
    ) %>%
    kableExtra::kable_styling(
      latex_options=c("repeat_header", "hold_position"),
      repeat_header_method = "replace") %>%
    kableExtra::footnote(number = levels(packages$library))

}

#' Style package information as flextable.
#'
#' @description Provide a \code{\link[flextable]{flextable}} formatted output
#' for the package information.
#'
#' @param packages The packages tibble from
#'    \code{\link[sessioninfo]{session_info}}
#' @return A \code{\link[flextable]{flextable}} formatted object.
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @examples
#' style_package_information_as_flextable(get_package_information())
style_package_information_as_flextable <- function(packages) {
  packages %>%
    dplyr::select(.data$package, .data$`*`, .data$version,
                  .data$date, .data$lib, .data$source) %>%
    flextable::flextable() %>%
    flextable::set_caption("Supplemental Table: Package Version Information") %>%
    flextable::theme_booktabs() %>%
    flextable::footnote(i=1, j=5,
                        value = flextable::as_paragraph(
                          paste(1:nlevels(packages$library),
                                "=",
                                levels(packages$library),
                                collapse="\n")
                        ),
                        ref_symbols="+",
                        part = "header"
    )



}



#' Print R Session information as formatted output.
#'
#'This function will print out the R sessioninfo() information
#'and some other variables in several tables for reproducibility.
#'
#'NB: This turns out to be difficult because the individual functions
#'need to have the kable call as the last thing (so I think an implicit
#'return) but *cannot* have a return() statement. The calling function
#'should store the values, then print() the results. Clearly there are
#'several functions being too clever by half in the stack.
#'
#' @return Nothing is returned, side effect is printed kable's.
#' @export
#'
print_session_information<-function() {

  table1<-style_environment_information_as_kable(get_environment_information())
  table2<-style_package_information_as_kable(get_package_information())

  print(table1)
  print(table2)
  invisible(TRUE)
}




#' Print the Session Information Markdown
#'
#' @description Session information can be printed in a rmarkdown report. This
#' function printss the necessary text to make it look nice in the markdown.
#'
#' @details
#' Session information is an important part of data science reports, since it
#' provides the package information and system configuration when the report
#' was originally generated.
#'
#' This function prints to the screen the necessary rmarkdown that can be
#' included in the source of a report. When the report is rendered, the
#' session information will be included.
#'
#' @note This function does not generate a report, only the markdown needed
#' to generate such a report during \code{\link[rmarkdown]{render}}.
#'
#' @param f File object to append markdown to (stdout by default).
#'
#' @return A string representing the rmarkdown needed for session information.
#' @export
#'
#' @examples
#' cat_session_markdown()
cat_session_markdown <- function(f=stdout()) {
  cat("
<!---
ATTENTION: The below text should remain at the bottom of your markdown
as it provides tables about the runtime environment. Leave
everything from the start of this paragraph down to the end of the
document.
--->
\\newpage
# Session Information
The information in this section is included in the report to facilitate
reproducible research. The specific environment under which the code was
run is detailed.
```{r session-information, echo=FALSE, results='asis'}
dsreportr::print_session_information()
```
  ")
}

#' Output session markdown text to file
#'
#' @description In the spirit of the `usethis` package, output the
#' text for including session information into the end of the named
#' markdown file.
#'
#' @param f A filename to append session markdown information to.
#'
#' @return Nothing
#' @export
#'
use_session_markdown <- function(f) {
  cat_session_markdown(file(f, open="a"))
}
