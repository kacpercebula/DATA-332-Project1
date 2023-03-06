library(tidytext)
library(textdata)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)
library(wordcloud)
library(sentimentr)
library(reshape2)
library(readr)
library(shiny)
library(DT)
library(lubridate)

consCompData <- read_rds("consumerComplaintsData.rds") %>%
  dplyr::select(Issue, Company) %>%
  arrange(desc(Company)) %>%
  ungroup() %>%
  unnest_tokens(word, Issue)

dataset <- consCompData %>%
  inner_join(get_sentiments("bing")) %>%
  group_by(Company) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

column_names <- colnames(dataset)[-1]


ui <- fluidPage (
  
  titlePanel(title = "Explore Every Companies Complaint's Dataset"),
  h4('Companies Contriubution to Sentiments for All Complaints'),
  
  fluidRow(
    column(2,
           selectizeInput('company', 'Choose Companies', choices = unique(dataset$Company), multiple = TRUE)
    ),
    column(4,plotOutput('plot_01')),
    column(6,DT::dataTableOutput("table_01", width = "100%"))
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive ({
    dataset %>%
      filter(Company %in% input$company)
  })
  
  output$plot_01 <- renderPlot({
    filtered_data() %>%
      group_by(sentiment) %>%
      slice_max(n, n = 10) %>%
      ungroup() %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(n, word, fill = sentiment)) + 
      geom_col(show.legend = TRUE) + 
      labs(x = "Contribution to sentiment",
           y = NULL)
  })
  
  output$table_01 <- DT::renderDataTable(filtered_data(), options = list(pageLength = 4))
}

shinyApp(ui=ui, server=server)
