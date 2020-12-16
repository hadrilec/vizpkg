
#' Run R-Shiny vizpkg app
#'
#' @examples
#' \donttest{
#' # Run R-Shiny vizpkg app
#' vizpkgApp()
#' }
#' @export
vizpkgApp <- function() {
  appDir <- system.file("inst","shiny", "vizpkgApp", package = "vizpkg")
  appDir <- system.file("inst","shiny", "vizpkgApp", package = "vizpkg")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `vizpkg`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
