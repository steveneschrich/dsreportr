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



## Creating New Templates
There are a few tools to make creating derivative packages that incorporate
new templates. As an example, let's consider creating a new "bbireportr" 
package. More details on creating new packages can be found in a separate
vignette on the topic.

The easiest way to create a new template is not to, but rather just modify the YAML header from the skeleton markdown in a new file. That's great for a one-off. If that doesn't work, create a new package (based on devtools, at least in rstudio). Then, from the project directory:
```
dsreportr::create_template_in_package("bbireportr::bbi_pdf")
```

This will create the necessary files, etc to make a new template. Note that the function provides copious output during the creation.

What if you want a banner image? No problem, you can run:
```
dsreportr::use_banner("bbireportr::bbi_pdf", "imagebanner.jpg")
```
Note: at present only one image is supported and the image needs to end in banner.jpg or banner.png. 

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

