#===============================================================================
# This code imports SIRUS
#===============================================================================
var_select <- c("sirus_id", "unite_type", "stat_etat",  "ind_entreprise", "creat_daaaammjj",
                "ape", "eff_3112",  "eff_etp", "eff_non_sal", "eff_interim", "ca",
                "total_bilan", "nbet_a","stat_etat")
# SIRUS 2017
df <- data.table(read_sas(paste0(sirus_path, "GEN_AAA17171_DGENENTSAS/GENENT17.sas7bdat"), col_select = all_of(var_select)))

write_parquet(df, paste0(data_path, "out/1_intermediary/sirus_17.parquet"))

# SIRUS 2020
df <- data.table(read_sas(paste0(sirus_path, "GEN_AAA17201_DGENENTSAS/GENENT20.sas7bdat"), col_select = all_of(var_select)))
write_parquet(df, paste0(data_path, "out/1_intermediary/sirus_20.parquet"))

