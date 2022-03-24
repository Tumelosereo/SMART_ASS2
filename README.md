# SMART
Practice exercises for the SACEMA Modelling and Analytics Response Team (SMART) meetings. The project focuses on a particular aspect of outbreak response science, analytics, and modelling, skills development and application to real-world problems. The simulations are generated using the branching process model to generate the time series for the daily median cases. The estimated dates are plotted when South Africa reported about 1000 and 10000 cases.


# Software and R packages requirements
1. R - a statistical programming language
2. R Studio (recommended)- a user interface for R 

Packages to be installed and required to run the code in this repository:

ggplot2, bpmodels, dplyr, tidyr, purrr, readr and lubridate.

# Directory structure
This folder contains subfolders:
1. data - contains the cleaned data  
2. figs - contains figures resulting from the analysis
3. model_output - Contains outputs resulting from the model
4. resources - Contains PDFs and formats of references
5. scripts - Contains the main scripts for performing operations

# How to use this repository
1. Make sure to load the 
`sa_1k_cases.Rproj` project file in RStudio. If you're not using 
RStudio, be sure to set the root directory as sa_1k_cases.

2. Run `get_data.R`. The script take a raw data from github repository and perform data cleaning, i.e `sa_covid_upto_mar13_2020.rds`, which is saved at `./sa_1k_cases/data`.

2. Source `./scripts/ts_output_post_processing.R`. The script sources
other scripts in the same folder and produces and saves outputs such
as figures. If any of the folders to save to do not exist, it will create them.
If the raw data does not exist, it will download, clean, and save it to file for the analysis.

