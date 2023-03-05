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

rm(list = ls())

#sets my working directory
setwd("~/DATA-332/Project1")

#I will be using bing and nrc lexicons for this Analysis
#get_sentiments("bing")
#get_sentiments("nrc")


#reads in the data then turns it into rds so it can run quicker
#consumerComplaintsData <- read.csv("Consumer_Complaints.csv")
#saveRDS(consumerComplaintsData, "consumerComplaintsData.rds")
consCompData <- read_rds("consumerComplaintsData.rds")

#makes a temporary data frame with columns I specifically want.
temp_cc_data <- consCompData %>%
  dplyr::select(Complaint.ID, Date.received, Product, Sub.product, Issue, Sub.issue, 
                Company, State, ZIP.code, Consumer.consent.provided., 
                Submitted.via, Company.response.to.consumer, Timely.response.)



#Simple graph to visual the data, showing top 20 companys with most complaints, 
comp <- temp_cc_data %>%
  count(Company) %>%
  arrange(desc(n)) %>%
  head(comp, n = 20)

ggplot(comp, aes(x = reorder(Company, -n), y = n)) + 
  geom_bar(stat = "identity", fill = "lavender", color = "black") + 
  scale_x_discrete(name = "Company") + 
  theme(axis.text.x = element_text(size = 7, angle = 35)) +
  labs(x = "Company (Top 20)", y = "Count", title = "Top 20 Companies with Most Complaints") 

#Simple graph to visual the data, showing top products with most complaints, 
prod <- temp_cc_data %>%
  count(Product) %>%
  arrange(desc(n)) %>%
  head(comp, n = 20)

ggplot(prod, aes(x = reorder(Product, -n), y = n)) + 
  geom_bar(stat = "identity", fill = "lavender", color = "black") + 
  scale_x_discrete(name = "Company") + 
  theme(axis.text.x = element_text(size = 7, angle = 35)) +
  labs(x = "Products", y = "Count", title = "Complaints Per Product") 


#makes a data frame with each word separated and corresponding to product & company
tidy_comp <- temp_cc_data %>%
  select(Issue, Company, Product, Date.received, State) %>%
  arrange(desc(Company)) %>%
  ungroup() %>%
  unnest_tokens(word, Issue) %>%
  mutate(Date.received = as.Date(Date.received, format = "%m/%d/%Y")) 
tidy_comp$Date.received <- format(tidy_comp$Date.received, "%Y-%m")

date_seq <- seq(from = as.Date("2011-07-01"), to = as.Date("2016-11-01"), by = "month")
month_year <- format(date_seq, "%Y-%m")

#checks the most common anger word
nrc_anger <- get_sentiments("nrc") %>%
  filter(sentiment == "anger")

overall_common_anger_words <- tidy_comp %>%
  inner_join(nrc_anger) %>%
  count(word, sort = TRUE) %>%
  arrange(desc(n))

ggplot(data = overall_common_anger_words, aes(x = word, y = n, fill = n)) +
  geom_bar(stat = "identity", color = "black") +
  geom_text(aes(label = n), vjust = -0.5) +
  scale_fill_gradient(low = "white", high = "red") +
  labs(x = "Words", y = "Frequency", title = "Common Complaint Anger Words") +
  theme_bw() +
  theme(axis.text.x = element_text(size = 10, angle = 20, face = "bold"))

#frame with top 6 most complaint companies
topSixSentimentsComp <- tidy_comp %>%
  filter(Company == "Bank of America" | Company == "Wells Fargo & Company" | 
           Company == "Equifax" | Company == "Experian" |
           Company == "JPMorgan Chase & Co." | Company == "Citibank") %>%
  inner_join(get_sentiments("bing")) %>%
  count(Company, index = Date.received, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment = positive - negative) 
  
ggplot(topSixSentimentsComp, aes(index, sentiment, fill = Company)) +
  geom_col(show.legend = FALSE) +
  scale_x_discrete(breaks = month_year[c(1, 12, 24, 36, 48, 60)]) +
  facet_wrap(~Company, ncol = 2, scales = "free_x") +
  theme(axis.text.x = element_text(size = 7, angle = 20, face = "bold"))

#frame with top 4 most complaint products
topFourSentimentsProd <- tidy_comp %>%
  filter(Product == "Credit reporting" | Product == "Debt collection" | Product == "Bank account or service" |
  Product == "Credit card") %>%
  inner_join(get_sentiments("bing")) %>%
  count(Product, index = Date.received, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment = positive - negative) 
  

ggplot(topFourSentimentsProd, aes(index, sentiment, fill = Product)) +
  geom_col(show.legend = FALSE) +
  scale_x_discrete(breaks = month_year[c(1, 12, 24, 36, 48, 60)]) +
  facet_wrap(~Product, ncol = 2, scales = "free_x") +
  theme(axis.text.x = element_text(size = 7, angle = 20, face = "bold"))


#choosing equifax and Experian to compare wordcloud. Very similar
#Equifax
tidy_comp %>%
  filter(Company == "Equifax") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

#Experian
tidy_comp %>%
  filter(Company == "Equifax") %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

#positive negative sentiment analysis but it doesn't do any good. 
#tidy_comp %>%
#  filter(Company == "Equifax") %>%
#  inner_join(get_sentiments("bing")) %>%
#  count(word, sentiment, sort = TRUE) %>%
#  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
#  comparison.cloud(colors = c("gray20", "gray80"))
  


#dynamic choose which company to see which words contribute to its sentiment
  #Can choose multiple companies for one graph
dataset <- tidy_comp %>%
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



