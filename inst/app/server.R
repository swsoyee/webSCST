shinyServer(function(input, output, session) {
  source(file = "./components/input-panel/upload-data-preview.server.R", local = TRUE)
})
