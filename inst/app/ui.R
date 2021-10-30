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
            id = "main-sidebar"
        ),
        menuItem(
            text = "Contact",
            tabName = "contact",
            icon = icon("envelope")
        )
    ),
    body = dashboardBody(
        tabItems(
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
