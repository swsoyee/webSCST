output$show_quality_control <- renderUI({
  if (!is.null(global_data$scRNA)) {
    menuItem(
      text = "Quality Control",
      tabName = "quality_control",
      icon = icon("clipboard-check")
    )
  }
})
