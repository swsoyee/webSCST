#' Run the application of webSCST.
#'
#' @examples
#' if (interactive()) {
#'   run()
#' }
#' @export
run <- function() {
  app_dir <- system.file("app", package = "webSCST")
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing `webSCST`.",
      call. = FALSE
    )
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
