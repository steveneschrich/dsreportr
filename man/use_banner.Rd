% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_package.R
\name{use_banner}
\alias{use_banner}
\title{Use image as banner image in template}
\usage{
use_banner(tmpl, img)
}
\arguments{
\item{tmpl}{A template of the form \code{pkg::template_pdf}.}

\item{img}{A filename of an image to use as a banner.}
}
\description{
For a dsreportr derived template, an image can
be used as a banner. This will install an image in a package
directory, assuming the working directory is in the package
directory structure.
}
\details{
The template structure allows for a banner to be used within
a template. This function is inspired by the \code{usethis} package,
to "install" the image file into the appropriate location within
a package.
}
\examples{
\dontrun{use_banner("dsreportr::ds1_pdf", "image.png")}
}
