#===============================================================================
# This code imports the Contour des Entreprises Profilées 
#===============================================================================

contour_17 <- data.table(read_sas(paste0(contour_path, "GEN_AAA17170_DCONTOURSAS/CONTOUR17.sas7bdat")))
write_parquet(contour_17 , paste0(data_path, "out/1_intermediary/contour_17.parquet"))
contour_20 <- data.table(read_sas(paste0(contour_path, "GEN_AAA17200_DCONTOURSAS/CONTOUR20.sas7bdat")))
write_parquet(contour_20 , paste0(data_path, "out/1_intermediary/contour_20.parquet"))


