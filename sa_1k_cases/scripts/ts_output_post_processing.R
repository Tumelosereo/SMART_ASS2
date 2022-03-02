#Packages
library('dplyr')
library("ggplot2")
library('lubridate')


#Load the simulation output if it exists, else run the simulation script and load the results
simulation_output <- if (file.exists("./model_output/two_wks_daily_cases_projection.rds")) {
  readRDS("./model_output/two_wks_daily_cases_projection.rds")
} else {
  source("./scripts/generate_joint_ts.R", local = TRUE)
  simulation_output
}


#Source relevant scripts
source('./scripts/inputs.R')


# Calculate cases per simulation per day. 
simulation_output_mod <- simulation_output %>%
  mutate(day = ceiling(time))%>%
  group_by(sim_id, day) %>%
  summarise(cases = n(), .groups = "drop_last") %>%
  ungroup()

# Calculate daily median cases and attach observed dates.  
final_output <- simulation_output_mod %>% 
  arrange(day) %>% 
  group_by(day) %>% 
  summarise(median_cases = median(cases)) %>% 
  ungroup() %>% 
  mutate(date = dmy("05-03-2020") + 0:projection_end_day)


# Make plots.
cases_plot <- ggplot(data = final_output) +
  geom_bar(aes(x = date, y = median_cases),
           stat = "identity",
           fill = "tomato3",
           size = 1
  ) +
  scale_y_continuous(breaks = seq(0, max(final_output$median_cases), 10),
                     labels = seq(0, max(final_output$median_cases), 10)
                     ) +
  labs(x = 'Date', y = 'Daily cases (median)') + 
  theme_minimal(base_size = 14)

print(cases_plot)

#save the two weeks ahead median daily cases time series plot to file 
if(dir.exists('./figs')){
  ggsave(filename = './figs/cases_plot.jpg', 
         plot = cases_plot,
         width = 8.51,
         height = 5.67,
         units = 'in'
         )
}else{
  dir.create('./figs')
  ggsave(filename = './figs/cases_plot.jpg', 
         plot = cases_plot,
         width = 8.51,
         height = 5.67,
         units = 'in'
  )
}
