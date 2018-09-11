library(shiny)
library(dplyr)
library(tidyr)

shinyUI(fluidPage(
    titlePanel("IMDB Movies"),
    sidebarLayout(
        sidebarPanel(
            h3("Choose your movie characteristics:"),
            selectInput("language",
                        "What is the language of titles your are after?",
                        c("All","Arabic","Bengali","Bulgarian","Catalan; Valencian",
                          "Croatian","English","French","German",
                          "Hebrew","Hindi","Indonesian","Italian","Kannada",
                          "Malayalam","Marathi","Panjabi; Punjabi","Persian",
                          "Russian","Serbian","Slovenian","Spanish; Castilian",
                          "Swedish","Tagalog","Tamil","Telugu","Thai","Turkish","Urdu")),
            selectInput("genre",
                        "What is the genre of titles your are after? (Note: a movie can have multiple genres)",
                        c("All","Action","Adult","Adventure","Animation","Biography","Comedy",
                          "Crime","Documentary","Drama","Family","Fantasy","Film-Noir",
                          "Game-Show","History","Horror","Music","Musical","Mystery",
                          "News","Reality-TV","Romance","Sci-Fi","Sport",
                          "Talk-Show","Thriller","War","Western")),
            textInput("title", "Title name contains (e.g., Redemption):"),
            sliderInput("year", "Production Year(s):",
                        1940, 2018, value = c(1940, 2018)),
            sliderInput("rating", "IMDB Rating:",
                        1, 10, value = c(1, 10), step = .1),
            br(),
            numericInput("nrows", "Top N movies that meet your criteria:", value = 20, 
                         min = 1, max = 100, step = 1),
            helpText("Note that the movies are sorted by IMDB Rating, Number of Votes, and the Production Year, accordingly.")
        ),
        mainPanel(
            h3("List of Movies that meet your desired characteristics"),
            h5("Note: The Table is sorted by IMDB Rating, Number of Votes, and the Production Year, accordingly."),
            br(),
            tableOutput("requested"),
            br(),
            helpText("You can download this table in a CSV format"),
            downloadButton("downloadData", "Download")
        )
    )
))
