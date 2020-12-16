shinyServer(function(input,output,session) {

  node = reactiveVal()
  edge = reactiveVal()
  function_visible = reactiveVal()

observe({
  pkg = input$pkg

  if(!is.null(pkg)){
    if(pkg %in% available_packages){

      vizpkg_folder = file.path(rappdirs::user_data_dir(), "vizpkg")
      list_folders = c(vizpkg_folder, file.path(vizpkg_folder, "vizpkg"))

      for(ifile in 1:length(list_folders)){
        if(!file.exists(list_folders[ifile])){
          dir.create(list_folders[ifile])
        }
      }

      version = "0.1.0"

      edge_file_cache = file.path(rappdirs::user_data_dir("vizpkg"),
                                      paste0(openssl::md5(sprintf("%s_%s_edge", pkg, version)), ".rds"))

      node_file_cache = file.path(rappdirs::user_data_dir("vizpkg"),
                                  paste0(openssl::md5(sprintf("%s_%s_node", pkg, version)), ".rds"))

      function_visible_file_cache = file.path(rappdirs::user_data_dir("vizpkg"),
                                  paste0(openssl::md5(sprintf("%s_%s_function_visible", pkg, version)), ".rds"))

      list_file_cache = c(edge_file_cache, node_file_cache, function_visible_file_cache)

      if(any(!file.exists(list_file_cache))){

        list_function = get_function(pkg)
        list_function_visible = get_function(pkg, all_function = FALSE, load_function = FALSE)

        withProgress(message = "Making package's network", value = 0, {
          list_df = dplyr::bind_rows(
            lapply(1:length(list_function),
                   function(i_f1){

                     f1_name = list_function[i_f1]
                     eval(parse(text = sprintf('`%s`<-%s:::`%s`', f1_name, pkg, f1_name)))
                     # df_function = as.data.frame(deparse(get(f1_name)))
                     function_text = paste0(deparse(get(f1_name)), collapse = " ")

                     loc_usemethod = stringr::str_locate_all(function_text, "UseMethod\\(")[[1]]

                     list_edge = list()

                     if(all(!is.na(loc_usemethod[1]))){
                       # print(loc_usemethod)
                       for(i_loc in 1:nrow(loc_usemethod)){
                         func = substr(function_text, loc_usemethod[i_loc,][2] + 1, nchar(function_text))
                         func = substr(func, 1, stringr::str_locate(func, "\\)")[[1]] - 1)
                         func = gsub('"', '', func)
                         func = gsub("'", '', func)
                         list_related_func = list_function[stringr::str_detect(list_function, paste0("^", func, "\\.\\.*"))]

                         if(length(list_related_func) > 0){
                           for(i_f in 1:length(list_related_func)){
                             i_f2 = which(list_function == list_related_func[i_f])
                             edge = data.frame(from = i_f1, to = i_f2)
                             list_edge[[length(list_edge) + 1]] = edge
                           }
                         }

                         }
                     }

                       for(i_f2 in 1:length(list_function)){

                         f2_pattern = paste0(list_function[i_f2],"\\(")

                         if(stringr::str_detect(function_text, f2_pattern)){
                           edge = data.frame(from = i_f1, to = i_f2)
                           list_edge[[length(list_edge) + 1]] = edge
                         }
                       }

                     # for(irow in 1:nrow(df_function)){
                     #   for(i_f2 in 1:length(list_function)){
                     #
                     #     f2_pattern = paste0(list_function[i_f2],"\\(")
                     #
                     #     if(stringr::str_detect(df_function[irow,1], f2_pattern)){
                     #       edge = data.frame(from = i_f1, to = i_f2)
                     #       list_edge[[length(list_edge) + 1]] = edge
                     #     }
                     #   }
                     # }

                     incProgress(1/length(list_function), detail = paste0(": ",
                                                                          round(i_f1/length(list_function)*100) ,"%"))

                     return(dplyr::bind_rows(list_edge))
                   })
          )
        })


        edge_pkg = list_df %>% dplyr::distinct()

        node_pkg = data.frame(id = 1:length(list_function),
                              label = list_function,
                              shape = "ellipse") %>%
          dplyr::mutate(shape = dplyr::case_when(!label %in%  list_function_visible ~ "triangle",
                                                 TRUE ~ as.character(.data$shape)))

        saveRDS(edge_pkg, file = edge_file_cache)
        saveRDS(node_pkg, file = node_file_cache)
        saveRDS(list_function_visible, file = function_visible_file_cache)

      }else{
        edge_pkg = readRDS(file = edge_file_cache)
        node_pkg = readRDS(file = node_file_cache)
        list_function_visible = readRDS(file = function_visible_file_cache)
        message(sprintf("Cached data used for : %s", pkg))
      }

      function_visible(list_function_visible)
      edge(edge_pkg)
      node(node_pkg)

      output$network <- renderVisNetwork({
        vizpkg2(edge(), node()) %>%
          visOptions(highlightNearest = TRUE, #highlights the node selected and the nearest nodes
                     nodesIdSelection = list(enabled = TRUE, values =  c(node_pkg[order(node_pkg[,'label']),'id']) ,selected = "1") #select directly a node
                     ) %>%
          # visIgraphLayout() %>%
          # visEdges(smooth = FALSE) %>%
          visNetwork::visEvents(click = "function(nodes){
                                Shiny.onInputChange('click', nodes.nodes[0]);
                                ;}")
    })

      output$shiny_return <- renderPrint({
        visNetworkProxy("network") %>%
          visNearestNodes(target = input$click)
      })

    }


  }

})

observe({

  nodes = node()


  output$fun <- renderPrint({
    if(!is.null(input$click)){

      ff = nodes[which(nodes[,'id'] == input$click),'label']
      print(ff)
      ff = gsub('.R','',ff)
      if(exists(ff)){
        get(ff)
      }


    }
  })



  if(!is.null(input$pkg)){
    if(input$pkg %in% pkg_installed[,1]){
      if(!is.null(input$click)){

        function_name = nodes[which(nodes[,'id'] == input$click),'label']

        if(length(function_name) > 0){
          if(function_name %in% function_visible()){

            file <- help(function_name, input$pkg)

            pkgname <- basename(dirname(dirname(file)))

            if(file.exists(file)){
              temp <- tools::Rd2HTML(utils:::.getHelpFile(file), out = tempfile("Rtxt"),
                                     package = pkgname)

            }


            # dest_file = file.path(tempdir(), sprintf("%s.html", function_name))
            # file.copy(temp, dest_file,)

            output$doc <- renderUI({
              # includeHTML(sprintf("~/test.html"))
              includeHTML(temp)

            })
          }
        }

#
#         link_vignette = file.path(system.file(package = input$pkg), "doc")
#         file_vignette = list.files(link_vignette, pattern = ".html$")
#         Print(file_vignette)
#         if(length(file_vignette) > 0){
#
#           output$vignette <- renderUI({
#             includeHTML(file.path(link_vignette, file_vignette[1]))
#           })
#
#         }


      }


      # pkg_html_path = file.path(system.file(package = input$pkg), "html")
      # list_html_files = list.files(pkg_html_path)
      #
      # function_documented = which(gsub(".html", "", list_html_files) %in% function_visible())
      # if(length(function_documented) > 0){
      #   list_html_files = list_html_files[function_documented]
      #
      #   if(!is.null(input$click)){
      #
      #     function_name = nodes[which(nodes[,'id'] == input$click),'label']
      #     file_selected = paste0(function_name, ".html")
      #     print(list_html_files)
      #     print(file_selected)
      #
      #     if(file_selected %in% list_html_files){
      #       print("get doc")
      #       output$doc <- renderUI({
      #         includeHTML(file.path(pkg_html_path, file_selected))
      #       })
      #     }
      #
      #
      #   }
      #
      #   # Print(list_html_files)
      # }


    }

  }





})
}
)
