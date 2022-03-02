#Packages
library(readr)
library(dplyr)
library(lubridate)

#Script to pull the data from Github
#URL to the raw data
data_url <- 'https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_confirmed.csv'

#Read the data in using the url
sa_covid_data <- read_csv(data_url)


#Clean and subset the data we need
sa_data_subset <- sa_covid_data %>% 
  mutate(date = dmy(date)) %>% 
  select(date) %>% 
  filter(date <= dmy('13-03-2020')) %>% 
  group_by(date) %>% 
  summarise(cases = n()) %>% 
  ungroup()

#save the cleaned data to file '
if(dir.exists('./data')){
  saveRDS(sa_data_subset, file = './data/sa_covid_upto_mar13_2020.rds')
}else{
  dir.create('./data')
  saveRDS(sa_data_subset, file = './data/sa_covid_upto_mar13_2020.rds')
}
