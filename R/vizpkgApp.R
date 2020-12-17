
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
  if (appDir == "") {
    appDir <- system.file("shiny", "vizpkgApp", package = "vizpkg")
  }

  shiny::runApp(appDir, display.mode = "normal")
}
