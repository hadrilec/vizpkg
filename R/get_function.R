#' List all functions in a package
#'
#' @details List all functions in a package, including internal functions
#' @param pkg a package name
#' @return a character vector
#' \donttest{
#' get_function("insee")
#' }
#' @export
get_function = function(pkg, all_function = TRUE, load_function = TRUE){

  pkg_installed = utils::installed.packages()
  if(!pkg %in% pkg_installed[,1]){
    utils::install.packages(pkg)
  }
  library(pkg, character.only = TRUE)

  if(all_function){
    list_function = unclass(utils::lsf.str(envir = asNamespace(pkg), all = T))
  }else{
    list_function = utils::lsf.str(sprintf("package:%s", pkg))
  }

  function_excluded = grep("\\[", list_function)
  if(length(function_excluded) > 0){
    list_function = list_function[-function_excluded]
  }
  function_excluded = grep("<-", list_function)
  if(length(function_excluded) > 0){
    list_function = list_function[-function_excluded]
  }

  if(load_function){
    for(function_name in list_function){
      # print(function_name)
      eval(parse(text = sprintf('`%s`<-%s:::`%s`', function_name, pkg, function_name)))
      assign(function_name, get(function_name), envir = .GlobalEnv)
    }
  }


  return(list_function)
}


