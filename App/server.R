library(shiny)
library(readr)
library(dplyr)
library(tidyr)

movies <- read_csv("movies.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session){
    
    df <- reactive({
        minyear <- input$year[1]
        maxyear <- input$year[2]
        minrating <- input$rating[1]
        maxrating <- input$rating[2]
        genre <- input$genre
        language <- input$language
        title <- as.character(input$title)
        
        movies <- movies %>%
            filter(
                startYear >= minyear,
                startYear <= maxyear,
                averageRating >= minrating,
                averageRating <= maxrating
                )
        
        if (input$genre != "All") {
            movies <- movies %>% filter(grepl(genre, genres, ignore.case = TRUE))
        }
        

        if (input$language != "All") {
            movies <- movies %>% filter(Language == language)
        }
    

        if (!is.null(input$title) && input$title != "") {
            movies <- movies %>% filter(grepl(title, primaryTitle, ignore.case = TRUE))
        }
        
        movies <- movies %>% 
            arrange(desc(averageRating), desc(numVotes), startYear)
        movies
    })

    output$requested <- renderTable({
        head(df(), n= input$nrows)
    })
    
    output$downloadData <- downloadHandler(
        filename = function() {
            paste("MoviesList-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(head(df(), n= input$nrows), file)
        }
    )
})


