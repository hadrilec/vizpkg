#' Find the links between a package's functions
#'
#' @details Find the links between a package's functions, including internal functions
#' @param pkg a package name
#' @return a character vector
#' \donttest{
#' edge = get_edge("insee")
#' }
#' @export
get_edge = function(pkg){

  list_function = get_function(pkg)

  if(length(list_function) > 1){
    pb = utils::txtProgressBar(min = 1, max = length(list_function), initial = 1, style = 3)
  }


  list_df = dplyr::bind_rows(
    lapply(1:length(list_function),
                   function(i_f1){

                     f1_name = list_function[i_f1]
                     eval(parse(text = sprintf('`%s`<-%s:::`%s`', f1_name, pkg, f1_name)))
                     df_function = as.data.frame(deparse(get(f1_name)))

                     list_edge = list()

                     for(irow in 1:nrow(df_function)){
                       for(i_f2 in 1:length(list_function)){

                         f2_pattern = paste0(list_function[i_f2],"\\(")

                         if(stringr::str_detect(df_function[irow,1], f2_pattern)){
                           edge = data.frame(from = i_f1, to = i_f2)
                           list_edge[[length(list_edge) + 1]] = edge
                         }
                       }
                     }

                     if(length(list_function) > 1){
                       utils::setTxtProgressBar(pb, i_f1)
                     }

                     return(dplyr::bind_rows(list_edge))
                   })
  )

  list_df = list_df %>% dplyr::distinct()

  return(list_df)
}

