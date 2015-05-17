teachR
======

`teachR` is a package for [`R`](http://www.r-project.org) that bundles several 
[`Shiny`](http://shiny.rstudio.com/) web applications for educational use. 

The goal of `teachR` is to provide teachers and educators with free, easy-to-use
and interactive applications for complementing their courses with virtual 
demonstrations and/or experiments. 

The [`Shiny`](http://shiny.rstudio.com/) applications in `teachR` can be launched 
directly from within [`R`](http://www.r-project.org) or [`RStudio`](http://www.rstudio.com). 
They can also be exported toward a local folder for later deployment 
on [`shinyapp.io`](https://www.shinyapps.io/) or on a personal 
[`Shiny Server`](http://www.rstudio.com/products/shiny/shiny-server/) instance. 

The `teachR` package is at a very early stage of development. It contains only a 
few [`Shiny`](http://shiny.rstudio.com/) applications at the moment, but this 
number is meant to grow with the help [`Shiny`](http://shiny.rstudio.com/) 
developers willing to make their educational web applications more easily 
accessible. 

If you are a [`Shiny`](http://shiny.rstudio.com/) developer and want to 
participate, just fork this repository, add your application(s) to the "inst/apps" 
folder with a properly formatted "info" file (see other apps for examples), and 
send me a pull request. 

---

#### Installation
Installing `teachR` from this GitHub repository is pretty straightforward: 
simply copy the following lines of code in your R terminal: 

```{r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("swarm-lab/teachR")

library(teachR)
```

Use the package's help to learn how to discover and run the applications provided
in `teachR`. 

---

#### Maintainer(s)
Simon Garnier - [@sjmgarnier](https://twitter.com/sjmgarnier) - 
<garnier@njit.edu>

---