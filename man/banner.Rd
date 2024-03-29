% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/banner.R
\name{banner}
\alias{banner}
\title{Return path to template banner image}
\usage{
banner(tmpl = "dsreportr::ds_pdf", img_extensions = c("png", "jpg"))
}
\arguments{
\item{tmpl}{A string representing a rmarkdown template, with the package
prefix. For example, \code{dsreportr::ds_pdf}.}

\item{img_extensions}{A list of image extensions to look for (default is \code{c("png","jpg")}).}
}
\value{
A path to a banner image.
}
\description{
Each template can have a banner image to show on the
first page of the report. This function returns the path to that
banner.
}
\note{
If there are multiple .png/.jpg etc files, then
the first such file is returned.
}
\examples{
\dontrun{
banner("ds_reportr::ds_pdf")
}
}
