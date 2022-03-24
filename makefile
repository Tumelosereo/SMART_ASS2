sa_1k_cases/data/sa_covid_upto_mar13_2020.rds: sa_1k_cases/scripts/get_data.R
        Rscript sa_1k_cases/scripts/get_data.R

sa_1k_cases/data/sa_covid_ts.rds: sa_1k_cases/scripts/inputs.R   sa_1k_cases/scripts/generate_joint_ts.R
        Rscipt  sa_1k_cases/scripts/generate_joint_ts.R


sa_1k_cases/figs/cum_plot.jpg:  sa_1k_cases/scripts/generate_joint_ts.R  sa_1k_cases/scripts/visualize.R
        Rscript sa_1k_cases/scripts/visualize.R