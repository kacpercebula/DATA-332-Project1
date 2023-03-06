# Project1 - Sentiment Analysis

## Description & Overview

In this project, I was given a dataset of consumer complaints from various different companies, Wells Fargo, Capital One, and Equifax for example. The data set included the issue, date recevied, company, product, etc. I wrote an R script program that cleans and analyzes the data using sentiment analysis. I chose specific companies to focus on, a specific word (anger) to use, and also some comaprisons between companies to understand more about the consumer complaints dataset. Also, in the ConsCompAnalysis, there is local code for a shiny app, however, I am also hosting the same shiny app that is comparing the specifc words and their sentiment contribution dynamically by allowing the user to choose which comapnies to anlayze, the link is provided right here -> https://kacpercebula.shinyapps.io/Project1/  

### Dependencies

* RStudio with readxl, dplyr, ggplot2, tidytext, textdata, stringr, tidyr, wordcloud, sentimentr, reshape2, readr, shiny, DT, and lubridate libraries installed.

### Installing

* Download all the files from github, link provided in the rscript and make sure it is all in one file.

### Executing program

* Open RStudio
* Click "Open an existing project"
* Select the ConsCompAnalysis.R
* Set the working directory in the beginning of the code
* Read through the program quickly
* Run the program

## Data Cleaning & Preparing

Cleaning was necessarly very easy and simple. To put it simply, first I selected columns out of the raw dataset that I wanted to analyze, then run this code... 
```r
tidy_comp <- temp_cc_data %>%
  select(Issue, Company, Product, Date.received, State) %>%
  arrange(desc(Company)) %>%
  ungroup() %>%
  unnest_tokens(word, Issue) %>%
  mutate(Date.received = as.Date(Date.received, format = "%m/%d/%Y")) 
tidy_comp$Date.received <- format(tidy_comp$Date.received, "%Y-%m")
```
I did clean up the date since it wasn't in the format I needed.


## Analysis


## Help

Make sure to set working directory properly and have the necessary libraries installed.

## Author

Kacper Cebula

## Version History

* 1.0
    * Initial Release

## Credits

Dr. Brosius
