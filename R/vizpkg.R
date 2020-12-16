#' Visualise links between functions in a package
#'
#' @details Visualise links between functions in a package
#' @param pkg a package name
#' @return a visnetwork object
#' @examples
#' \donttest{
#' vizpkg("rwebstat")
#' vizpkg("insee")
#' vizpkg("rsdmx")
#' }
#' @export
#' @importFrom magrittr "%>%"
#' @importFrom rlang ".data"
vizpkg = function(pkg){

  list_function = get_function(pkg)
  list_function_visible = get_function(pkg, all_function = FALSE)

  edge = get_edge(pkg)

  node = data.frame(id = 1:length(list_function),
                    label = list_function,
                    shape = "ellipse") %>%
    dplyr::mutate(shape = dplyr::case_when(!label %in%  list_function_visible ~ "triangle",
                                           TRUE ~ as.character(.data$shape)))

  viz =
    visNetwork::visNetwork(node, edge,
              height = "100%", width = "100%",
              main = "") %>%
    visNetwork::visEdges(arrows = "to")  %>%  #put arrows
    visNetwork::visPhysics(solver = "forceAtlas2Based",
                           forceAtlas2Based = list("avoidOverlap" = 0.05))

  return(viz)
}

vizpkg2 = function(edge, node){

  viz =
    visNetwork::visNetwork(node, edge,
                           height = "100%", width = "100%",
                           main = "") %>%
    visNetwork::visEdges(arrows = "to")  %>%  #put arrows
    visNetwork::visPhysics(solver = "forceAtlas2Based",
                           forceAtlas2Based = list("avoidOverlap" = 0.05))

  return(viz)
}








