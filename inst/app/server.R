shinyServer(function(input, output, session) {
  source(file = "./components/input-panel/upload-data-preview-matrix.server.R", local = TRUE)
  source(file = "./components/input-panel/upload-dataset-summary.server.R", local = TRUE)
})
