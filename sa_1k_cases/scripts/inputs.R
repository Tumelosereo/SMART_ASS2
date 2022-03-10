#Packages
library(dplyr)
library(tidyr)
library(purrr)

#Helper functions
source('./scripts/helper_functions.R')

# # command-line arguments


args <- commandArgs()

if (length(args) > 3 ) {
  sigma = 2
  mu = 5
  sim_id = 4
  
} else(length(args) == 3) {
  sigma = args[1]
  mu = args[2]
  sim_id = args[3]
}

#Get the cleaned data
dat <- if (file.exists("./data/sa_covid_upto_mar13_2020.rds")) {
  readRDS("./data/sa_covid_upto_mar13_2020.rds")
} else {
  source("./scripts/get_data.R", local = TRUE)
  readRDS("./data/sa_covid_upto_mar13_2020.rds")
}

#bpmodels inputs
dat <- dat %>% 
  mutate(days_from_t0 = as.integer(date - min(date)))

#'Create a vector of day differences from day 1 equal to the number of cases per date
days_from_t0 <- unlist(map2(.x = dat$days_from_t0, 
                            .y = dat$cases,
                            .f = function(.x, .y)return(rep(.x, times = ifelse(.y == 0, 1, .y)))
                              )
                       )


#Date to end simulation
projection_end_day <- max(days_from_t0) + 14 #14 day projection


#Simulation controls
number_of_sims <- 100

#Serial interval distribution (must be input as a function) ----
si_sd <- cal_desired_lognorm_sd(mu = 4.7, sigma = 2.9) #the desired standard deviation
si_mean <- cal_desired_lognorm_mu(mu = 4.7, sigma = 2.9) #the desired mean

#function to specify serial interval
serial_interval <- function(sample_size = 1) {
  si <- rlnorm(sample_size, meanlog = si_mean, sdlog = si_sd)
  return(si)
  }
