# Packages
library("bpmodels")
library("dplyr")
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

(ggplot(final_output)
  + aes(x = day, y = cum_cases, col = as.factor(sim_id))
  + geom_line()+theme(legend.position = "none")
  + scale_color_manual(values = rep("red", number_of_sims))
    
  
)





















































































#save the two weeks ahead time series projection to file 
if(dir.exists('./model_output')){
  saveRDS(simulation_output, file = './model_output/two_wks_daily_cases_projection.rds')
}else{
  dir.create('./model_output')
  saveRDS(simulation_output, file = './model_output/two_wks_daily_cases_projection.rds')
}


