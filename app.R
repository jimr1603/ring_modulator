library(shiny)
library(tuneR)

ui <- fluidPage(
   
   # Application title
   titlePanel("Ring Modulation"),
   
   # Sidebar with a slider input
   sidebarLayout(
      sidebarPanel(
        radioButtons("shape_1", "shape of wave 1", c("noise", "pulse", "sawtooth", "sine", "square")),
        radioButtons("shape_2", "shape of wave 2", c("noise", "pulse", "sawtooth", "sine", "square")),
        actionButton("playsound", label = "Play")
        ),
      
      mainPanel(
        sliderInput("freq_1", "frequency 1", 1, 1000, 440),
        sliderInput("freq_2", "frequency 2", 1, 1000, 440)
        
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observeEvent(input$playsound, {
    
    if(input$shape_1 == "noise"){
      wave_1 <- noise("white")
    }
    else{
      wave_1 <- do.call(input$shape_1, list(input$freq_1))     
    }
    
    if(input$shape_2 == "noise"){
      wave_2 <- noise("white")
    }
    else{
      wave_2 <- do.call(input$shape_2, list(input$freq_2))     
    }
    writeWave(wave_1*wave_2, "www/playme.wav")
    
    insertUI(selector = "#playsound",
             where = "beforeEnd",
             ui = tags$audio(src = "playme.wav", type = "audio/wav", autoplay = T,  controls = T, style="display:none;")
    )
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

