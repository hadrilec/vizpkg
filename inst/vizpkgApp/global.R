
#version of R > 3.5
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjqui)
library(shinyWidgets)

library(visNetwork)
library(stringr)

library(colorspace)
library(RColorBrewer)


#install.packages(c("devtools",'xml2', "roxygen2", "testthat", "knitr"))

Print = function(x){print(deparse(substitute(x)));print(x)}
# setwd("C:/Users/eurhope/Desktop/codeMap")
# load('network_functions.RData')
available_packages = available.packages()
available_packages = available_packages[,"Package"]

pkg_installed = utils::installed.packages()

##
list_clr=c(brewer.pal(n=8, name = "Set1"))
#exclude yellow
clr2=c(brewer.pal(n=8, name = "Dark2"))
list_clr=c(list_clr,clr2)
##

list_clr=c(brewer.pal(n=8, name = "Set1"))
list_clr=list_clr[-6] #exclude yellow
list_clr=c(list_clr,c(brewer.pal(n=8, name = "Dark2")))
list_clr=rep(list_clr,10)

list_clr2 <- readhex(file = textConnection(paste(list_clr, collapse = "\n")),
                     class = "RGB")
#transform to hue/lightness/saturation colorspace
list_clr2 <- as(list_clr2, "HLS")

#additive decrease of lightness
list_clr2@coords[, "L"] <- pmax(0, list_clr2@coords[, "L"] + 1)

list_clr2<- as(list_clr2, "RGB")
list_clr <- hex(list_clr2)


