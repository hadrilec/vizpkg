

shinyUI(
  dashboardPagePlus(
    enable_preloader = F,

    dashboardHeaderPlus(title = "vizpkg", titleWidth = 285, enable_rightsidebar = FALSE,
                        # tags$li(class = "dropdown",
                        #         tags$style(".main-header {max-height: 50px}")
                        # ),


                        left_menu =
                          tagList(
                            # tags$style(HTML(".selectize-input {height: 5px;}")),
                            # tags$style(type = 'text/css', '#pkg  {margin-bottom:-15px}'),
                          selectizeInput('pkg', label = NULL,
                                         choices = available_packages,
                                          multiple = FALSE,
                                         options = list(
                                           placeholder = "Select a CRAN package",
                                           onInitialize = I('function() { this.setValue(""); }')
                                         )
                                         )

                        )
                        ),

    dashboardSidebar(width = "0px"),
    ## Body content
    dashboardBody(
                fluidRow(
                   jqui_resizable( boxPlus(
                                  width = 6, height = '900px',
                                  title = "Package code map",
                                  closable = F,
                                  status = "warning",
                                  solidHeader = FALSE,
                                  collapsible = F,
                                  enable_sidebar = FALSE,
                                  visNetworkOutput("network",  height = 840, width = "100%")
                                ))
                               ,
                  jqui_resizable(
                    # tags$style(type = 'text/css', '#fun  {font-size: 12px; font-family: calibri light; background-color: rgba(255,255,255,0.40); color: black;}'),
                               tabBox(width=6, height = '900px',
                                      tabPanel('Function',
                                               tags$style(type = 'text/css', '#fun  {font-size: 12px; font-family: calibri light; background-color: rgba(255,255,255,0.40); color: black;}'),
                                               verbatimTextOutput("fun")
                                      ),
                                      tabPanel('Documentation',
                                               htmlOutput("doc")
                                      )


                               )
                  )
                )
    )
  ))


