fluidPage(
  fluidRow(
    box(
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      title = tagList(
        "Database"
      ),
      withSpinner(reactableOutput("database_table"))
    )
  )
)
