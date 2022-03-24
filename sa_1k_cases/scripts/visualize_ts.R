library("dplyr")
library("tidyr")
library("ggplot2")

source("./scripts/generate_joint_ts.R", local = TRUE)

threshold <- 1000

# final_output %>% group_by(sim_id) %>% summarise(maxcases = max(cum_cases)) 
#%>% pull(maxcases) %>% summary()

# Calculating Count the number of case that are at specified number of cases
# for each simulation

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

# final_output %>% group_by(sim_id) %>% summarise(maxcases = max(cum_cases)) 
# %>% pull(maxcases) %>% summary()

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

# cum_plot <- (ggplot(final_output)
#              + aes(x = day, y = cum_cases, col = as.factor(sim_id))
#              + geom_line()
#              + theme(legend.position = "none")
#              + scale_color_manual(values = rep("red", number_of_sims))
#              + lims(y = c(0,12000))
#              
# )
# 
# print(cum_plot)


final_output <- (final_output
                 %>% mutate(date  = day+min(dat$date))
)

cum_plot <- (ggplot(final_output)
             +
               aes(x = date, y = cum_cases, col = as.factor(sim_id))
             +
               geom_line(alpha = 0.2)
             +
               theme(legend.position = "none")
             +
               scale_color_manual(values = rep("red", number_of_sims))
             +
               lims(y = c(0, 12000), x = c(min(dat$date), min(dat$date) + 70)) # improve limit axis specs
             +
               geom_point(
                 mapping = aes(x = median_cases_date, y = threshold),
                 col = "black", size = 3
               )
             +
               geom_segment(
                 mapping = aes(
                   x = ci_l_cases_date,
                   xend = ci_u_cases_date,
                   y = threshold, yend = threshold
                 ),
                 col = "black", size = 1
               )
             +
               geom_point(
                 mapping = aes(x = median_cases_date_10g, y = threshold_10g),
                 col = "black", size = 3
               )
             +
               geom_segment(
                 mapping = aes(
                   x = ci_l_cases_date_10g,
                   xend = ci_u_cases_date_10g,
                   y = threshold_10g, yend = threshold_10g
                 ),
                 col = "black", size = 1
               )
            
)


print(cum_plot)

# Save cases time series plot to file

if(dir.exists('./figs')){
  ggsave(filename = './figs/cum_plot.jpg', 
         plot = cum_plot,
         width = 8.51,
         height = 5.67,
         units = 'in'
  )
}else{
  dir.create('./figs')
  ggsave(filename = './figs/cum_plot.jpg', 
         plot = cum_plot,
         width = 8.51,
         height = 5.67,
         units = 'in'
  )
}


