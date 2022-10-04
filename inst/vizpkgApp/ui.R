

shinyUI(
  dashboardPage(
    dashboardHeader(title = "vizpkg",
                    titleWidth = 285
                        #,
                        # leftUi  =
                        #   tagList(
                          # selectizeInput('pkg', label = NULL,
                          #                choices = available_packages,
                          #                 multiple = FALSE,
                          #                options = list(
                          #                  placeholder = "Select a CRAN package",
                          #                  onInitialize = I('function() { this.setValue(""); }')
                          #                )
                          #                )

                        # )
                        ),

    dashboardSidebar(width = "0px"),
    ## Body content
    dashboardBody(
                fluidRow(
                   jqui_resizable( visNetworkOutput("network",  height = 840, width = "100%")
                                )
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


