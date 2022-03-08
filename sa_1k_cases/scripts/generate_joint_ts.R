
# Packages

library("bpmodels")
library("dplyr")
library("tidyr")
library("ggplot2")


# Source the inputs
source("./scripts/inputs.R", local = TRUE)

set.seed(1234)

## Chain log-likelihood simulation
simulation_output_list <- lapply(
  1:number_of_sims,
  function(ii) {
    chain_sim(
      n = length(days_from_t0), # number of chains to simulate.
      offspring = "nbinom",
      mu = 2.0,
      size = 0.38,
      stat = "size",
      infinite = 10000,
      tree = TRUE,
      serial = serial_interval,
      t0 = days_from_t0,
      #tf = projection_end_day
    ) %>%
      mutate(sim_id = ii)
  }
)

# Unlist and bind simulation results.
simulation_output <- bind_rows(simulation_output_list, .id = "column_label")

#Add new columns to the results
simulation_output_mod <- simulation_output %>% 
  mutate(day = floor(time))

final_output <- simulation_output_mod %>% 
  group_by(sim_id, day) %>% 
  summarise(cases = n()) %>% 
  arrange(sim_id, day) %>% 
  group_by(sim_id) %>% 
  mutate(cum_cases = cumsum(cases)) %>% 
  ungroup()

# Count the number of case that are at specified number of cases

target<- final_output %>%
  filter(sim_id == 1) %>% 
  filter(cum_cases >= 1000) %>% 
  pull(day) %>% 
  min()

# The targeted cases

threshold <- 1000

# final_output %>% group_by(sim_id) %>% summarise(maxcases = max(cum_cases)) %>% pull(maxcases) %>% summary()

# Calculating for each simulation

my_threshold <- lapply(1:number_of_sims, function(ii){
  target<- final_output %>%
    filter(sim_id == ii) %>% 
    filter(cum_cases >= threshold) %>% 
    pull(day) %>% 
    min() 
})

# Calculating the median and the quantile

count_1k <- unlist(my_threshold)
median_cases <- median(count_1k)
ci_cases <- quantile(count_1k, probs = c(0.25, 0.95))

median_cases_date <-  median_cases + min(dat$date)
ci_l_cases_date <-  ci_cases[1] + min(dat$date)
ci_u_cases_date <-  ci_cases[2] + min(dat$date)
  

# The targeted cases
# TO improve - write as function for 1000 and 1000

threshold_10g <- 10000

# final_output %>% group_by(sim_id) %>% summarise(maxcases = max(cum_cases)) %>% pull(maxcases) %>% summary()

# Calculating for each simulation

my_threshold_10g <- lapply(1:number_of_sims, function(ii){
  target<- final_output %>%
    filter(sim_id == ii) %>% 
    filter(cum_cases >= threshold_10g) %>% 
    pull(day) %>% 
    min() 
})

# Calculating the median and the quantile

count_10g <- unlist(my_threshold_10g)
median_cases_10g <- median(count_10g)
ci_cases_10g <- quantile(count_10g, probs = c(0.25, 0.95))

median_cases_date_10g <-  median_cases_10g + min(dat$date)
ci_l_cases_date_10g <-  ci_cases_10g[1] + min(dat$date)
ci_u_cases_date_10g <-  ci_cases_10g[2] + min(dat$date)



# Plot 

cum_plot <- (ggplot(final_output)
  + aes(x = day, y = cum_cases, col = as.factor(sim_id))
  + geom_line()
  + theme(legend.position = "none")
  + scale_color_manual(values = rep("red", number_of_sims))
  + lims(y = c(0,12000))
  
)




print(cum_plot)


final_output <- (final_output
                 %>% mutate(date  = day+min(dat$date))
)



cum_plot <- (ggplot(final_output)
             + aes(x = date, y = cum_cases, col = as.factor(sim_id))
             + geom_line(alpha = 0.2)
             + theme(legend.position = "none")
             + scale_color_manual(values = rep("red", number_of_sims))
             + lims(y = c(0,12000), x = c(min(dat$date), min(dat$date) + 70)) # improve limit axis specs
              + geom_point(mapping = aes(x=median_cases_date, y = threshold), col = 'black', size  = 3)
            + geom_segment(mapping = aes(x=ci_l_cases_date, xend = ci_u_cases_date, y= threshold, yend = threshold), col = 'black', size = 1)
             + geom_point(mapping = aes(x=median_cases_date_10g, y = threshold_10g), col = 'black', size  = 3)
            + geom_segment(mapping = aes(x=ci_l_cases_date_10g, xend = ci_u_cases_date_10g, y= threshold_10g, yend = threshold_10g), col = 'black', size = 1)
             )


print(cum_plot)

# 

ggsave('cum_plot.png',cum_plot)





