shinyUI(
  dashboardPage(
    title = "webSCST",
    scrollToTop = TRUE,
    fullscreen = TRUE,
    header = dashboardHeader(
      title = dashboardBrand(
        title = "webSCST",
        color = "primary",
        image = "./logo.png"
      ),
      leftUi = tags$li(
        "webSCST: an interactive web application for single-cell RNA-seq data and spatial transcriptome data integration",
        class = "dropdown",
        style = "margin:auto;"
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
          text = "Database",
          tabName = "database",
          icon = icon("database")
        ),
        menuItem(
          text = "Data Integration",
          tabName = "data-integration",
          icon = icon("object-group")
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
          tabName = "about",
          source(file = "./pages/about.R", local = TRUE)$value
        )
      )
    ),
    footer = dashboardFooter(
      left = tagList(
        "Copyright (c) 2021, ",
        tags$a(
          href = "http://lab.malab.cn/~zq/en/index.html",
          "MAchine Learning And Bioinformatics (MALAB), "
        ),
        tags$a(
          href = "https://en.uestc.edu.cn/",
          " UESTC."
        )
      )
    )
  )
)
