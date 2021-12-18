fluidPage(
  fluidRow(
    box(
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      collapsible = FALSE,
      title = tagList(
        "About"
      ),
      includeMarkdown("www/about.md")
    )
  )
)
