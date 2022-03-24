
# Packages

library("bpmodels")
library("dplyr")
library("tidyr")


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

#save the cleaned data to file '
if(dir.exists('./data')){
  saveRDS(final_output, file = './data/sa_covid_ts.rds')
}else{
  dir.create('./data')
  saveRDS(final_output, file = './data/sa_covid_ts.rds')
}

