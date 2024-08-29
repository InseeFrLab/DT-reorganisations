#===============================================================================
# This code imports DADS Postes 2017 to create firm-level and business function-level datasets
#===============================================================================


# We must combine the files for each region and each department of Ile-de-France
list_data_region <- c("24","27", "28", "32", "44", "52", "53", "75", "76", "84", "93", "94")
list_data_paris <- c("75", "77", "78", "91", "92", "93", "94", "95")

import_dads_region <- function(rr){
  base <- read_sas(paste0(dads_path, "HAB_A118017B_DPOR", rr, "SAS/POST.sas7bdat"))
  ## Filtrer les double-compte
  dads <- base %>% filter(REGT ==rr | (REGT == "" & REGT_1 == rr))
  ## Garder uniquement les entreprises priv?es
  dads <- base %>% filter(!startsWith(as.character(CATJUR), "4") & !startsWith(as.character(CATJUR), "7") & !startsWith(as.character(CATJUR), "9"))
  ## Agr?ger par type de poste
  dads <- dads %>% group_by(SIREN, PCS) %>% summarise(wage_f = sum(BRUT_F), wage_ss = sum(BRUT_S), wage_brut = sum(S_BRUT), nb_workers = n(), nb_heures = sum(NBHEUR), nb_eqtp = sum(EQTP))
  name <- paste0("dads",rr)
  return(assign(name, dads))
}

data <- lapply(list_data_region, import_dads_region)

import_dads_paris <- function(dd){
  base <- read_sas(paste0(dads_path, "HAB_A118017B_DPOD", dd, "SAS/POST.sas7bdat"))
  ## Filtrer les double-compte
  dads <- base %>% filter(DEPT ==dd | (DEPT == "" & DEPT_1 == dd))
  ## Garder uniquement les entreprises priv?es
  dads <- base %>% filter(!startsWith(as.character(CATJUR), "4") & !startsWith(as.character(CATJUR), "7") & !startsWith(as.character(CATJUR), "9"))
  ## Agr?ger par type de poste
  dads <- dads %>% group_by(SIREN, PCS) %>% summarise(wage_f = sum(BRUT_F), wage_ss = sum(BRUT_S), wage_brut = sum(S_BRUT), nb_workers = n(), nb_heures = sum(NBHEUR), nb_eqtp = sum(EQTP))
  name <- paste0("dads", dd)
  return(assign(name, dads))
}
data_paris <- lapply(list_data_paris, import_dads_paris)

# Combine regions and Paris
out_paris <- rbind(data_paris[[1]], data_paris[[2]], data_paris[[3]], data_paris[[4]], data_paris[[5]], data_paris[[6]], data_paris[[7]], data_paris[[8]])
out <- rbind(data[[1]], data[[2]],data[[3]],data[[4]],data[[5]], data[[6]], data[[7]], data[[8]], data[[9]], data[[10]], data[[11]], data[[12]], out_paris)

# Sum by Firm*Occupation
out_small <- out %>% group_by(SIREN, PCS) %>% summarise(wage_f=sum(wage_f), wage_ss=sum(wage_ss), wage_brut=sum(wage_brut), nb_workers=sum(nb_workers), nb_heures = sum(nb_heures), nb_eqtp=sum(nb_eqtp))


# Firm-level
out_38 <- out_small %>% filter(startsWith(PCS, "38")) %>% group_by(SIREN) %>% summarise(wage_brut_inge = sum(wage_brut, na.rm=TRUE), eqtp_inge = sum(nb_eqtp, na.rm=TRUE), nb_heures_inge = sum(nb_heures, na.rm=TRUE)) 
out_38a <- out_small %>% filter(startsWith(PCS, "383A") | startsWith(PCS, "384A") | startsWith(PCS, "385A") | startsWith(PCS, "386B") | startsWith(PCS, "386C") | startsWith(PCS, "388A")) %>% group_by(SIREN) %>% summarise(wage_brut_RD = sum(wage_brut, na.rm=TRUE), eqtp_RD = sum(nb_eqtp, na.rm=TRUE), nb_heures_RD = sum(nb_heures, na.rm=TRUE)) 
out_techies <- out_small %>% filter(startsWith(PCS, "38")|startsWith(PCS, "47")) %>% group_by(SIREN) %>% summarise(wage_brut_techies = sum(wage_brut, na.rm=TRUE), eqtp_techies = sum(nb_eqtp, na.rm=TRUE), nb_heures_techies = sum(nb_heures, na.rm=TRUE)) 
out_highskilled <- out_small %>% filter(startsWith(PCS, "3")|startsWith(PCS, "2")) %>% group_by(SIREN) %>% summarise(wage_brut_HS = sum(wage_brut, na.rm=TRUE), eqtp_HS = sum(nb_eqtp, na.rm=TRUE), nb_heures_HS = sum(nb_heures, na.rm=TRUE)) 
out_tot <- out_small %>% group_by(SIREN) %>% summarise(wage_brut = sum(wage_brut, na.rm=TRUE), eqtp = sum(nb_eqtp, na.rm=TRUE), nb_heures = sum(nb_heures, na.rm=TRUE)) 

wages <- merge(merge(merge(merge(out_tot, out_38, by.x="SIREN", by.y="SIREN", all.x=TRUE), out_38a, by.x="SIREN", by.y="SIREN", all.x=TRUE), out_techies, by.x="SIREN", by.y="SIREN", all.x=TRUE), out_highskilled, by.x="SIREN", by.y="SIREN", all.x=TRUE)

wages <- wages %>% replace(is.na(.),0)

write_parquet(wages, paste0(data_path,"out/1_intermediary/dads_2017_entreprise.parquet"))

## Industry-level
sirus17 <- read_parquet(paste0(data_path, "out/1_intermediary/sirus_17.parquet")) %>% 
  filter(!startsWith(sirus_id, "P")) %>% mutate(industry = substr(ape, 1, 3)) %>% select(sirus_id, industry)

dataset_industry <- merge(out_small, sirus17, by.x = "SIREN", by.y = "sirus_id", all.x = TRUE)
dataset_industry<- dataset_industry %>% group_by(industry, PCS) %>% select(-SIREN) %>% summarise_each(funs(sum(., na.rm = TRUE)))

write_parquet(dataset_industry, paste0(data_path, "out/1_intermediary/dads_2017_industry.parquet"))
