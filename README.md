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

2. Source `./scripts/ts_output_post_processing.R`. The script sources
other scripts in the same folder and produces and saves outputs such
as figures. If any of the folders to save to do not exist, it will create them.
If the raw data does not exist, it will download, clean, and save it to file for the analysis.

