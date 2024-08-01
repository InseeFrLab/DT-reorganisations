#===============================================================================
# Reorganizing global supply-chains: Who, What, How, and Where
# Master
#===============================================================================
## Paths of databases
cam_path <- "X:/HAB-CAM-Perim/cam-perim/data/cam/data/"
contour_path <- "W:/AAA17/"
fare_path <- "W:/AAA04/"
sirus_path <- "W:/AAA17/"
dads_path <- "X:/HAB-DADS-Mise-a-disposition/"
gravity_path <- "X:/HAB-CAM-Perim/cam-perim/data/gravity/source/"
## Path to store confidential data
data_path <- "X:/HAB-CAM-Perim/cam-perim/"
## Path where the code folder is
global_path <- "Z:/reorganisations_replication_package/" 
## Path where to store results
output_path <- "Z:/reorganisations_replication_package/output/" 

setwd(global_path)
#===============================================================================
source("code/1_0_headers.R")
source("code/1_1_cam.R")
source("code/1_2_contour.R")
source("code/1_3_fare.R")
source("code/1_4_sirus.R")
source("code/1_5_dads.R")
source("code/1_6_1_build_contour_17.R")
source("code/1_6_2_build_cam_augmented.R")
source("code/1_7_business_function_data.R")
source("code/1_8_destination_data.R")
source("code/1_9_build_regdata.R")
source("code/2_2_1_Table_1.R")
source("code/2_2_2_Table_2.R")
source("code/2_2_3_Table_3.R")
source("code/2_2_4_Table_4.R")
source("code/2_5_supplementary_results.R")
