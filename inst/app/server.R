shinyServer(function(input, output, session) {
  source(file = "./components/input-panel/upload-data-preview.server.R", local = TRUE)
  source(file = "./components/input-panel/upload-data-preview-feature.server.R", local = TRUE)
})
