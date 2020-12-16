#' @noRd
clean_vizpkg_folder = function(){

  list_file_insee = file.path(rappdirs::user_data_dir("vizpkg"),
                              list.files(rappdirs::user_data_dir("vizpkg")))

  if(length(list_file_insee) > 0){
    for(file_name in list_file_insee){
      file.remove(file_name)
    }
  }
}
