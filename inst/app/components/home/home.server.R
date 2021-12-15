observeEvent(input$sc_data_uploading_and_processing, {
  updateTabItems(
    session,
    "main_sidebar",
    selected = "file-upload"
  )
})

observeEvent(input$spatial_transcriptome_database, {
  updateTabItems(
    session,
    "main_sidebar",
    selected = "database"
  )
})

observeEvent(input$go_to_integration_tab, {
  updateTabItems(
    session,
    "main_sidebar",
    selected = "data-integration"
  )
})
