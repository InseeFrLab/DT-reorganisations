#===============================================================================
# This code builds the factor content of business functions
#===============================================================================

# 1. FARE and DADS -------------------------------------------------------------
## Import data -----------------------------------------------------------------
fare_17 <- read_parquet(paste0(data_path, "out/1_intermediary/fare_17.parquet")) 

fare_short <- fare_17 %>% dplyr::select(siren,
                                        siren_ent,
                                        NAF=ape_diff,
                                        sales = redi_r310,
                                        caf = redi_r420,
                                        L = redi_e200,
                                        va = r004,
                                        vaht=redi_r003,
                                        Y = redi_r001,
                                        capital = actinet_tot,
                                        K_corp = immo_corp,
                                        K_b = i352,
                                        K_m = i255,
                                        K_inc = immo_inc,
                                        I_corp = inv_corp,
                                        I_corp_b = inv_corp_c,
                                        I_corp_m = inv_corp_it, 
                                        I_incorp = inv_incorp,
                                        redi_r216, 
                                        redi_r217,
                                        redi_r212,
                                        redi_r214,
                                        EBE= redi_r005) %>%
  mutate(W := redi_r216 + redi_r217) %>% 
  mutate(K := K_corp + K_inc) %>% 
  mutate(I := I_corp + I_incorp) %>% 
  mutate(achats := redi_r212 + redi_r214) %>% 
  mutate(fare = 1)%>%
  select(-redi_r216, -redi_r217)

dads17 <- read_parquet(paste0(data_path, "out/1_intermediary/dads_2017_entreprise.parquet"))

dads_fare_matched<- merge(fare_short, dads17, by.x = "siren", by.y = "SIREN") 

## Aggregate to the business function level  -----------------------------------
vars <- c("K", "K_corp", "K_b", "K_m", "K_inc", "I", "I_corp", "I_corp_b", "I_corp_m", "I_incorp", "L", "va", "sales", "achats", "W",
          "wage_brut", "wage_brut_RD", "wage_brut_HS", "nb_heures", "nb_heures_HS", "nb_heures_RD")

dads_fare_aggr <- dads_fare_matched %>%
  mutate_at(vars(wage_brut, wage_brut_RD, wage_brut_HS), funs(ifelse(is.na(.), 0, .))) %>%
  mutate_at(vars(wage_brut, wage_brut_RD, wage_brut_HS), funs(./1000)) %>%
  filter(wage_brut>0)%>%
  mutate(secteur = case_when(
    as.numeric(substr(NAF, 1, 2)) >= 2 & as.numeric(substr(NAF, 1, 2)) <= 39 & substr(NAF, 1, 2) != "19" ~ "IND",
    substr(NAF, 1, 2) %in% c("41", "42", "43") ~ "CONS",
    substr(NAF, 1, 2) %in% c("49", "50", "51", "52", "53") ~ "TRP",
    substr(NAF, 1, 2) %in% c("45", "46", "47", "73")~ "COM",
    substr(NAF, 1, 3) %in% c("822", "823")~ "COM",
    substr(NAF, 1, 2) %in% c("61", "62", "63") ~ "SI",
    substr(NAF, 1, 2) %in% c("69", "78") ~ "ADMIN",
    substr(NAF, 1, 3) =="702" ~ "ADMIN",
    substr(NAF, 1, 2) == "71" ~ "ING",
    substr(NAF, 1, 2) == "72" ~ "RD",
    TRUE ~ "AUTRE"
  )) %>%
  group_by(secteur) %>%
  summarise(
    across(all_of(vars), sum, na.rm = TRUE)
  ) %>%
  mutate(HS_frac = nb_heures_HS/nb_heures,
         RD_frac = nb_heures_RD/nb_heures) %>%
  mutate(K_inc_K = K_inc/(K_inc+K_corp))

# Create intensive variables
divide_by_var <- function(x, var) {
  x / dads_fare_aggr[[var]]
}
new_vars <- lapply(vars, function(x) divide_by_var(dads_fare_aggr[[x]], "wage_brut"))
new_var_names <- paste0(vars, "_wage_brut")
dads_fare_aggr[new_var_names] <- new_vars


dads_fare_aggr["K_L"] <- lapply(c("K"), function(x) divide_by_var(dads_fare_aggr[[x]], "L"))

dads_fare_aggr["RD_sales"] <- lapply(c("wage_brut_RD"), function(x) divide_by_var(dads_fare_aggr[[x]], "sales"))
# 2. Routineness ---------------------------------------------------------------

dataset_industry <- read_parquet(paste0(data_path, "out/1_intermediary/dads_2017_industry.parquet"))
routine_measure <- haven::read_dta(paste0(data_path, "data/ONET/PCSESE_task_measures.dta"))
corresp <- haven::read_dta(paste0(data_path, "data/ONET/PCSESEtoPCS.dta"))

dataset_industry <- dataset_industry %>% rename(NAF = industry) %>%
  mutate(secteur = case_when(
    as.numeric(substr(NAF, 1, 2)) >= 2 & as.numeric(substr(NAF, 1, 2)) <= 39 & substr(NAF, 1, 2) != "19" ~ "IND",
    substr(NAF, 1, 2) %in% c("41", "42", "43") ~ "CONS",
    substr(NAF, 1, 2) %in% c("49", "50", "51", "52", "53") ~ "TRP",
    substr(NAF, 1, 2) %in% c("45", "46", "47", "73")~ "COM",
    substr(NAF, 1, 3) %in% c("822", "823")~ "COM",
    substr(NAF, 1, 2) %in% c("61", "62", "63") ~ "SI",
    substr(NAF, 1, 2) %in% c("69", "78") ~ "ADMIN",
    substr(NAF, 1, 3) =="702" ~ "ADMIN",
    substr(NAF, 1, 2) == "71" ~ "ING",
    substr(NAF, 1, 2) == "72" ~ "RD",
    TRUE ~ "AUTRE"
  )) %>%
  group_by(secteur, PCS) %>%
  select(-"NAF") %>%
  summarise_each(funs(sum(., na.rm = TRUE))) %>%
  mutate(PCS = tolower(PCS))


dataset_industry <- merge(dataset_industry, routine_measure, by.x = "PCS", by.y = "PCSESECode", all = TRUE)

routine_industry <- dataset_industry %>% group_by(secteur) %>%
  summarise(avg_nr = weighted.mean(nr_cog_anal+nr_cog_pers+nr_man_al, nb_heures, na.rm = TRUE),
            avg_nr_cog_anal = weighted.mean(nr_cog_anal, nb_heures, na.rm = TRUE),
            avg_nr_cog_pers = weighted.mean(nr_cog_pers, nb_heures, na.rm = TRUE),
            avg_nr_man_al = weighted.mean(nr_man_al, nb_heures, na.rm = TRUE),
            avg_r = weighted.mean(r_cog + r_man, nb_heures, na.rm = TRUE),
            avg_r_cog = weighted.mean(r_cog, nb_heures, na.rm = TRUE),
            avg_r_man = weighted.mean(r_man, nb_heures, na.rm = TRUE),
            avg_w_nr = weighted.mean(nr_cog_anal+nr_cog_pers+nr_man_al, wage_brut, na.rm = TRUE),
            avg_w_nr_cog_anal = weighted.mean(nr_cog_anal, wage_brut, na.rm = TRUE),
            avg_w_nr_cog_pers = weighted.mean(nr_cog_pers, wage_brut, na.rm = TRUE),
            avg_w_nr_man_al = weighted.mean(nr_man_al, wage_brut, na.rm = TRUE),
            avg_w_r = weighted.mean(r_cog+r_man, wage_brut, na.rm = TRUE),
            avg_w_r_cog = weighted.mean(r_cog, wage_brut, na.rm = TRUE),
            avg_w_r_man = weighted.mean(r_man, wage_brut, na.rm = TRUE))


# Save -------------------------------------------------------------------------
factor_content <- merge(dads_fare_aggr, routine_industry, by.x = "secteur", by.y = "secteur")

write_rds(factor_content, paste0(data_path, "out/2_final/factor_content.rds"))
