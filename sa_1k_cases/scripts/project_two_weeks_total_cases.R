#Packages
library("bpmodels")
library('dplyr')
library('ggplot2')

#Source the inputs
source('./scripts/inputs.R')

set.seed(1234)
## Chain log-likelihood simulation
simulation_output <- map_dfr(1:number_of_sims,
  function(id) {
    out <- chain_sim(
    n = length(days_from_t0),
    offspring = "nbinom",
    mu = 2.0,
    size = 0.38,
    stat = "size",
    infinite = 1E7,
    serial = serial_interval,
    t0 = days_from_t0,
    tf = projection_end_day,
    tree = TRUE
    ) %>% 
      mutate(sim_id = id)
    return(out)
    }
)

#Add new columns to the results
simulation_output_mod <- simulation_output %>% 
  mutate(day = floor(time)) 

final_output <- simulation_output_mod %>% 
  group_by(sim_id, day) %>% 
  summarise(cases = n(), .groups = 'drop_last') %>% 
  summarise(cum_cases = cumsum(cases)) %>% 
  slice_max(cum_cases) %>% 
  ungroup()

#make plots
cases_plot <- ggplot(data = final_output) + 
  geom_boxplot(aes(cum_cases), 
           color = 'blue',
           size = 1
           )

print(cases_plot)



