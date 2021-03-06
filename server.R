library(shiny)
library(shinyjs)
library(shinyURL)

credentials <- list("test" = "202cb962ac59075b964b07152d234b70")

shinyServer(function(input, output) {
  shinyURL.server()
  
  USER <- reactiveValues(Logged = FALSE)
  
  observeEvent(input$.login, {
    if (isTRUE(credentials[[input$.username]]==input$.password)){
      USER$Logged <- TRUE
    } else {
      show("message")
      output$message = renderText("Invalid user name or password")
      delay(2000, hide("message", anim = TRUE, animType = "fade"))
    }
  })
  
  output$app = renderUI(
    if (!isTRUE(USER$Logged)) {
      fluidRow(column(width=4, offset = 4,
        wellPanel(id = "login",
          textInput(".username", "Username:"),
          passwordInput(".password", "Password:"),
          div(actionButton(".login", "Log in"), style="text-align: center;")
        ),
        textOutput("message")
      ))
    } else {
        # Sidebar with a slider input for number of bins
        sidebarLayout(
          sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            shinyURL.ui()
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            plotOutput("distPlot")
          )
        )
      
    }

  )
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  
})
