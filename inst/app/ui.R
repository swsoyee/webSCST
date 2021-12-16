shinyUI(
  dashboardPage(
    title = "webSCST",
    header = dashboardHeader(
      title = dashboardBrand(
        title = "webSCST",
        color = "primary",
        image = "./logo.png"
      )
    ),
    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "main_sidebar",
        menuItem(
          text = "Home",
          tabName = "home",
          icon = icon("home")
        ),
        menuItem(
          text = "File Upload",
          tabName = "file-upload",
          icon = icon("upload")
        ),
        menuItemOutput("show_quality_control"),
        menuItem(
          text = "Data Integration",
          tabName = "data-integration",
          icon = icon("object-group")
        ),
        menuItem(
          text = "Database",
          tabName = "database",
          icon = icon("database")
        ),
        menuItem(
          text = "About",
          tabName = "about",
          icon = icon("envelope")
        )
      ),
    ),
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "home",
          source(file = "./pages/home.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "file-upload",
          source(file = "./pages/input-panel.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "quality_control",
          source(file = "./pages/quality-control.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "data-integration",
          source(file = "./pages/data-integration.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "database",
          source(file = "./pages/database.R", local = TRUE)$value
        ),
        tabItem(
          tabName = "about"
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
