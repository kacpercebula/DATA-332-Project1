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

Cleaning was necessarly very easy and simple. To put it simply, first I selected columns out of the raw dataset that I wanted to analyze (easy enough using dplyr select), then ran this code... 
```r
tidy_comp <- temp_cc_data %>%
  select(Issue, Company, Product, Date.received, State) %>%
  arrange(desc(Company)) %>%
  ungroup() %>%
  unnest_tokens(word, Issue) %>%
  mutate(Date.received = as.Date(Date.received, format = "%m/%d/%Y")) 
tidy_comp$Date.received <- format(tidy_comp$Date.received, "%Y-%m")
```
At the end of that piece of code you can see I did clean up the date since it wasn't in the format I needed.
This gave me a workable tidy dataset to run sentiment analysis on.

## Data Summary

<img width="532" alt="Screen Shot 2023-03-05 at 7 38 32 PM" src="https://user-images.githubusercontent.com/113058755/223001993-aa0335b0-4afa-4436-84cd-f3414114ebcf.png">

* Here you can see the dataset I was working with to run analysis on. 
* It was grouped by Company from Z-A.

## Analysis

1. Simple graphs to show the amount of compaints per company and product. 

![Top20Comp](https://user-images.githubusercontent.com/113058755/223002525-054893d9-fce8-4dde-ba3b-e2ecc8e1bee9.png)

![CompPerProd](https://user-images.githubusercontent.com/113058755/223002544-942a0983-b38b-431a-8323-de64c39c11e8.png)

* This is a simple way of briefly showing what the data in the raw dataset is showing.
* As you can see, COMPANY & Mortgage had the most complaints in terms of comapny and product respectively. 
* I used count of the amount of "Company" there were since the raw dataset was necessarily already clean. 

2. A graph displaying the most common words that had the sentiment of "anger"

![CommAngerWords](https://user-images.githubusercontent.com/113058755/223002865-3555126b-4e57-4dc3-9930-7bffde0006cf.png)

* This allows us to see which weres words used in the complaints issue area
* 


## Help

Make sure to set working directory properly and have the necessary libraries installed.

## Author

Kacper Cebula

## Version History

* 1.0
    * Initial Release

## Credits

Dr. Brosius
