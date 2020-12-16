# from : https://stackoverflow.com/questions/11560865/list-and-description-of-all-packages-in-cran-from-within-r
# author : Dirk Eddelbuettel

get_pkg_CRAN <- function() {
  contrib.url(getOption("repos")["CRAN"], "source")
  description <- sprintf("%s/web/packages/packages.rds",
                         getOption("repos")["CRAN"])
  con <- if (substring(description, 1L, 7L) == "file://") {
    file(description, "rb")
  } else {
    url(description, "rb")
  }
  on.exit(close(con))
  db <- readRDS(gzcon(con))
  rownames(db) <- NULL

  db[, c("Package", "Title", "Description")]
}
# pkgs = get_pkg_CRAN()

# gtools::getDependencies("insee", dependencies = c("Imports"))
# devtools::revdep("ggplot2")
#
# available_packages = available.packages()
# available_packages = available_packages[,"Package"]
#
# pkg_limit = length(available_packages)
#
# pkg_limit = 100
#
# list_pkg = bind_rows(lapply(1:pkg_limit,
#                            function(i){
#                              print(i)
#                              pkg = as.character(available_packages[i])
#                              dpd =  gtools::getDependencies(pkg,
#                                                             dependencies = c("Imports"))
#                              if(length(dpd) == 0){dpd=NA}
#                              data.frame(pkg = pkg, dependency = dpd)
#
#                            }
#                            ))

