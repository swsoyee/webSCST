shinyUI(
  dashboardPage(
    title = "webSCST",
    header = dashboardHeader(
      title = dashboardBrand(
        title = "webSCST",
        color = "primary"
      )
    ),
    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "main_sidebar",
        menuItem(
          text = "File Upload",
          tabName = "file-upload",
          icon = icon("upload")
        ),
        menuItemOutput("show_quality_control"),
        menuItem(
          text = "Contact",
          tabName = "contact",
          icon = icon("envelope")
        )
      ),
    ),
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "file-upload",
          source(file = "./pages/input-panel.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "quality_control",
          source(file = "./pages/quality-control.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "contact"
        )
      )
    ),
    footer = dashboardFooter(
      left = tagList(
        tags$div("test")
      )
    )
  )
)
