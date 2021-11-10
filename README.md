# dsreportr

This package contains R code and template files necessary for creating
new templates easily for rmarkdown projects. What does that mean? There
are some plumbing utilities implemented here so that a new template package
can stick to defining the things that matter.

Some features of the package:
- A nice set of formatting utilities for printing out the R environment at the end of a markdown document, for reproducible research.
- Some helper functions for finding resources in a specific package structure for templates.

## Install
To install the package, use
```
devtools::install_github("steveneschrich/dsreportr")
```



## Creating New Packages
There are a few tools to make creating derivative packages that incorporate
new templates. As an example, let's consider creating a new "bbireportr" 
package. The basic components of the package that are required include:

### bbi_pdf.R

`R/bbi_pdf.R` is a wrapper around `bookdown::pdf_document2()` that provides
a way to insert the latex template. If this isn't clear, don't worry since there
isn't much that is needed. Since the template comes from this package (dsreportr), there is no need to do anything except name the function. Here is an example of what it could be:

```
bbi_pdf <- dsreportr::ds_pdf
```

However, if you want to use a roxygen2 template and use rstudio `Code->Insert Roxygen Skeleton`, then you would create a bit more:
```
bbi_pdf <- function(...) {dsreportr::ds_pdf(...)}
```

That's it. We can now specify in a YAML markdown report header:

```
output:
  bbireportr::bbi_pdf()
```

### Template
Next, we create the following directory: `inst/rmarkdown/templates/bbi_pdf`. 
This directory will hold the banner image (if you want one), the skeleton
markdown and the description of the template.

- The banner image is easy - put a jpg/png file in the `inst/rmarkdown/templates/bbi_pdf/resources` directory. Make sure that it is
called `SOMETHINGbanner.jpg` or `SOMETHINGbanner.png`. Case doesn't matter
but it needs to end in `banner.jpg` or `banner.png`. Of course, you also want to make sure it is appropriately sized (full width looks nice, but other options are reasonable). 

- A description of the template should be in `inst/rmarkdown/templates/bbi_pdf/template.yaml`. This is a simple file with only a couple of lines:
```
name: Biostatistics, Bioinformatics and Informatics PDF Report Output
description: A Biostatistics, Bioinformatics and Informatics PDF report.
create_dir: false
```
You may want more inspired text, but that is sufficient. Note that the name will show up in the `File->New File->R Markdown->Templates` selection in Rstudio.

- A skeleton markdown file, providing the necessary components to run the template. Note that this package provides a complete `skeleton.Rmd` file which can be copied to: `inst/rmarkdown/templates/bbi_pdf/skeleton`. You don't have 
to find the skeleton file, though. You could execute the following:
```
dsreportr::new_markdown("inst/rmarkdown/templates/bbi_pdf/skeleton/skeleton.Rmd")
```

From this file, you'll want to change two fields:

```
banner: "`r dsreportr::banner("bbireportr::bbi_pdf"")`"
output:
  bbireportr::bbi_pdf:
    latex_engine: pdflatex
    keep_tex: false
```

That's it. At this point, you should have a workable package that implements a new R markdown template.

## R Environment
The R environment from `base::sessionInfo` or `sessioninfo::session_info` are pretty nice for getting a snapshot of the current state of R, including R version, OS, date, and library package versions. There are a few more things that I've found useful, such as git-related settings, and username. Above all else, the most useful parameter is the *project directory*. Organizing across many projects, it is inevitable that the question of "Remember that project..." comes up. "Send me the report" is now my answer, since the directory will be at the bottom of the report.

The R session can be included in a rmarkdown report through the R function
```
dsreportr::print_session_information()
```

The default template in this package (and derived packages) includes a knitr chunk to do this. So you don't have to think about it. You can also execute 
```
dsreportr::use_session_markdown("file.Rmd")
```
to get the necessary markdown appended to the end of the file.


NB: Make sure the image banner part gets integrated and test the whole create package step next.
