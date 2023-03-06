# Project1 - Sentiment Analysis

## Description & Overview

In this project, I was given a dataset of consumer complaints from various different companies, Wells Fargo, Capital One, and Equifax for example. The data set included the issue, date recevied, company, product, etc. I wrote an R script program that cleans and analyzes the data using sentiment analysis. I chose specific companies to focus on, a specific word (anger) to use, and also some comaprisons between companies to understand more about the consumer complaints dataset. Worth noting is that I used the Issues within the data set to run analysis on. I did not use Sub.Issues or Consumer.complaint.narrative. Also, in the ConsCompAnalysis, there is local code for a shiny app, however, I am also hosting the same shiny app that is comparing the specifc words and their sentiment contribution dynamically by allowing the user to choose which comapnies to anlayze, the link is provided right here -> https://kacpercebula.shinyapps.io/Project1/  

### Dependencies

* RStudio with readxl, dplyr, ggplot2, tidytext, textdata, stringr, tidyr, wordcloud, sentimentr, reshape2, readr, shiny, DT, and lubridate libraries installed.
* Downloading the Dataset from this link providec ->  https://www.kaggle.com/datasets/ashwinik/consumer-complaints-financial-products

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
* As you can see, Bank of America & Mortgage had the most complaints in terms of comapny and product respectively. 
* I used count of the amount of "Company" there were since the raw dataset was necessarily already clean. 

2. A graph displaying the most common words that had the sentiment of "anger"

![CommAngerWords](https://user-images.githubusercontent.com/113058755/223002865-3555126b-4e57-4dc3-9930-7bffde0006cf.png)

* This allows us to see which weres words used in the complaints issue area
* As you can see, fraud, illegal, and threatening were the msot common words that had the sentiment "anger assigned to them. 
* I used the nrc lexicons and count to achieve this.

3. A graph showing comparisons between top companies sentiment totals overtime

![TopSixCompSent](https://user-images.githubusercontent.com/113058755/223017824-0d49583e-d882-46d9-b5f3-3d34472e4e12.png)

* The top six companies were chosen to see what their sentiments were overtime. As we can see, Bank of America, Citibank, JPMorgan Chase & Co., and Wells Fargo & Company all have similar sentiment totals that aren't relatively drastic and do not change overtime. Now on the other hand, Equifax and Experian sentiment totals are drastic and increase over time, although, Experian doesn't increase as much. 
* This shows use that certain companies may have more complaints, such as Bank of America (number one most complaints), but the compalaints aren't as intense./ 
* I achieved this by filtering the top companies, using/inner joining the bing lexicon, and then mutating the dataframe.

insert graph

4. A graph showing comparisons between the top porducts sentiment totals overtime. 

![TopFourProdSent](https://user-images.githubusercontent.com/113058755/223021915-4234065e-4727-47b7-ba7c-f5701d7c3f39.png)

* In this graph, I did a similar analysis with, for the most part, the top products. Here we can see just as Bank of America, etc, Bank account or service and Credit Card products and relatively low sentiment totals with no increase or decrease. Now as for Credit reporting and Debt collection, just like Equifax, etc, there sentiment totals are terribly negative. Credit reporting increased overtime while Debt collection stayed deeply negative for a while, no wonder.
* This allows us to see how certain products have terrible sentiment totals while some stay relatively nuetral. Obviously these are complaints we are talking about. 
* I achieved this just how I achieved the chart above, only this time I used products. 

5. These two word clouds allow us to compare the most used words in the complaints from each company. Top wordcloud is Equifax and bottom is Wells Fargo & Company.

![EquifaxWC](https://user-images.githubusercontent.com/113058755/223021981-0fac4272-667d-47dc-be93-db14176fad45.png)

![WellsFargoWC](https://user-images.githubusercontent.com/113058755/223021987-41370e2e-c08a-4616-826e-94ffc8ea90a9.png)

* In these words clouds, we can assume something about the companies as well. Equifax seems to work with credit since its main words seem to be credit, report, inccorect, information while Wells Fargo seems to be more banking side of things with common words being loan, foreclosure, collection, modification, payments. 
* This shows how each company, even though they have complaints, have specific issues they work with and have many complaints about. 
* I achieved this by using the wordcloud library with a few lines of code. 

6. This is a screenshot of the running shiny app you can view using this link -> https://kacpercebula.shinyapps.io/Project1/.  

<img width="1422" alt="Screen Shot 2023-03-05 at 10 55 46 PM" src="https://user-images.githubusercontent.com/113058755/223022591-1d05858e-aa8f-422b-b9c5-ecec15ee72e2.png">

* This shiny app allows the user to select which ever company they want, multiple if wanted, and see how different words affect the sentiment total for their complaints. The graph displays this information and the table shows with numerical values how each word affects the sentiment. It is dynamic, which is why the user can choose whichever company they want to analyze. 
* I achieved this by using the shiny app tutorial and researching a little bit about how to connect data, filter the data within the server, and finally actually make a running app through shinyapps.io

## Help

Make sure to set working directory properly and have the necessary libraries installed.

## Author

Kacper Cebula

## Version History

* 1.0
    * Initial Release

## Credits

Dr. Brosius
