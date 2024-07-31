#===============================================================================
# This code imports FARE
#===============================================================================
df <- data.table(read_sas(paste0(fare_path, "GEN_AAA0417U_DFAREM18SAS/FARE2017METH2018.sas7bdat")))
write_parquet(df ,paste0(data_path, "out/1_intermediary/fare_17.parquet"))

df <- data.table(read_sas("W:/AAA04/GEN_AAA0420U_DFAREM21SAS/FARE2020METH2021.sas7bdat"))
write_parquet(df ,paste0(data_path, "out/1_intermediary/fare_20.parquet"))

