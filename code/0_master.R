#===============================================================================
# Reorganizing global supply-chains: Who, What, How, and Where
# Master R file
#===============================================================================

## Data paths
cam_path <- Sys.getenv("cam_path")
contour_path <- Sys.getenv("contour_path")
fare_path <- Sys.getenv("fare_path")
sirus_path <- Sys.getenv("sirus_path")
dads_path <- Sys.getenv("dads_path")
gravity_path <- Sys.getenv("gravity_path")

## Path to store working data
data_path <- Sys.getenv("data_path")

## Working path
global_path <- Sys.getenv("global_path")

setwd(global_path)

## Where to store output
output_path <- Sys.getenv("output_path")

#===============================================================================
# load packages
pkglist <- c("dplyr", "tidyverse", "haven", "DT", "data.table", "arrow", "xtable") 
lapply(pkglist, library, character.only = TRUE)

# Import data
source("code/1_1_cam.R")
source("code/1_2_contour.R")
source("code/1_3_fare.R")
source("code/1_4_sirus.R")
source("code/1_5_dads.R")

# Correspondence EP 2020 - EP 2017 for CAM EP
source("code/1_6_1_build_contour_17.R")

# Convert CAM to 2017 firms + add firm-level data
source("code/1_6_2_build_cam_augmented.R")

# Create business function level data
source("code/1_7_business_function_data.R")

# Create destination level data
source("code/1_8_destination_data.R")

# Build datasets for regressions
source("code/1_9_build_regdata.R")

# Descriptive tables
source("code/2_2_1_Table_1.R")
source("code/2_2_2_Table_2.R")
source("code/2_2_3_Table_3.R")
source("code/2_2_4_Table_4.R")

# Additional results (figures in the main text)
source("code/2_5_supplementary_results.R")
