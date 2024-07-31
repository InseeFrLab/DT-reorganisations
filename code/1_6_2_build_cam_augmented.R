#===============================================================================
# This code builds the main dataset: CAM + FARE + DADS + SIRUS
#===============================================================================
# Import data ------------------------------------

cam_ep17 <- setDT(read_rds(paste0(data_path, "out/1_intermediary/cam_ep17.rds")))
cam  <- setDT(read_rds(paste0(data_path, "out/2_final/base_cam_cleaned.rds"))) %>% 
  rename(entreprise_20 = sirus_id)

sirus17 <- read_parquet(paste0(data_path, "out/1_intermediary/sirus_17.parquet"))

contour_2017 <- read_parquet(paste0(data_path, "out/1_intermediary/contour_17.parquet"))


# Import FARE ------------------------------------------------------------------
fare_short <- read_parquet(paste0(data_path, "out/1_intermediary/fare_17.parquet")) %>% 
              dplyr::select(siren,
                           siren_ent,
                           cat = redi_r310,
                           L_fare = redi_e200,
                           vacf= r004,
                           Y = redi_r001,
                           K = immo_corp,
                           inv_corp = inv_corp_b_ha,
                           inv_incorp = inv_incorp,
                           inv_corp_machinery = inv_corp_it,
                           achats_mp = redi_r212, 
                           redi_r216, 
                           redi_r217,
                           EBE= redi_r005) %>%
              mutate(W := redi_r216 + redi_r217) %>% 
              mutate(fare = 1)%>%
              select(-redi_r216, -redi_r217)

# Import DADS ------------------------------------------------------------------
dads_short <- read_parquet(paste0(data_path, "out/1_intermediary/dads_2017_entreprise.parquet")) %>% 
  rename(siren=SIREN) %>% 
  filter(!startsWith(siren, "P")) %>%
  mutate(dads = 1)

# We create the dataset of EP in 2017, choosing the preferred method for the correspondance EP20-EP17 -----
list_ep_recup <- cam_ep17 %>% 
  mutate(entreprise_17 =ifelse(is.na(entreprise_17_mlargest), entreprise_17_mtg, entreprise_17_mlargest),
         ep17 = ifelse(is.na(entreprise_17_mlargest), ep17_mtg, ep17_mlargest),
         uli17 = ifelse(is.na(entreprise_17_mlargest), uli17_mtg, uli17_mlargest),
         source = case_when(
           is.na(entreprise_17_mlargest) == FALSE ~ "mlargest",
           is.na(entreprise_17_mtg) == FALSE ~ "mtg",
           .default = "")) %>%
  select(c("entreprise_20", "entreprise_17", "uli17", "ep17", "source")) 

cam_recup <- cam %>% mutate(recup_ep = entreprise_20 %in% unique((list_ep_recup %>% filter(ep17 == 1))$entreprise_20))
cam_recup <- cam_recup %>% mutate(recup_uli = entreprise_20 %in% unique((list_ep_recup %>% filter(uli17 == 1))$entreprise_20))
cam_recup <- merge(cam_recup, list_ep_recup, by.x = "entreprise_20", by.y = "entreprise_20", all.x=TRUE)

# We flag single legal unit in 2017
cam_recup$uli17 <- ifelse(cam_recup$recup_uli == TRUE | cam_recup$ULI, 1, 0)
# We create the unique identifier of our firms in 2017
cam_recup$entreprise_17 <- ifelse(is.na(cam_recup$entreprise_17), cam_recup$entreprise_20, cam_recup$entreprise_17)

# In some cases, our procedure incidentally picked up some EP that were already in our dataset 
# It means that two EP in 2020 point to the same EP in 2017
# We favor the EP whose identifier did not change
cam_recup <- cam_recup %>% group_by(entreprise_17) %>% mutate(nb_obs = n())
cam_recup <- cam_recup %>% filter(nb_obs == 1 | (nb_obs == 2 & recup_ep == FALSE)) %>% select(-c("nb_obs"))

# We then build the legal unit-level dataset of firms that were EP in 2017 -----
contour_cam <- contour_2017 %>%
  filter(sirus_id %in% (cam_recup %>% filter(EP & uli17 == 0))$entreprise_17) %>%
  mutate(siren = ifelse(nchar(siren) < 9, str_pad(siren, width = 9, pad = "0"), siren)) %>%
  rename(entreprise_17=sirus_id) %>%
  dplyr::select(siren, entreprise_17) %>%
  mutate(contour=TRUE, UL=TRUE)

# Merge ------------------------------------------------------------------------

data_UL <- merge(fare_short, dads_short, by.x="siren", by.y="siren", all.x=TRUE)

merged_UL <- merge(data_UL, contour_cam, by.x = "siren", by.y = "siren", all.y = TRUE)

merged_ULI <- merge(data_UL, cam_recup %>% filter(uli17 == 1) %>% select(c("entreprise_17", "entreprise_20")), by.x = "siren", by.y = "entreprise_17", all.y = TRUE) %>%
  rename(entreprise_17 = siren)

cam_UL_merged <- rbind(merged_UL, merged_ULI, fill=TRUE)

# Aggregate up to the firm-level -----------------------------------------------

original_vars <- c("cat", "L_fare", "vacf", "Y", "K", "inv_corp", "inv_corp_machinery", "inv_incorp", "W", "EBE", "achats_mp", 
                   "wage_brut", "wage_brut_inge", "wage_brut_RD", "wage_brut_techies", "wage_brut_HS", 
                   "eqtp", "eqtp_inge", "eqtp_RD", "eqtp_techies", "eqtp_HS", 
                   "nb_heures", "nb_heures_inge", "nb_heures_RD", "nb_heures_techies", "nb_heures_HS")

table_aggr_EP_UL <- cam_UL_merged %>%
  filter(!is.na(entreprise_17)) %>%
  group_by(entreprise_17) %>%
  summarise(
    across(all_of(original_vars), sum, na.rm = TRUE),
    nb_ul = n()
  ) %>%
  mutate(EP = ifelse(startsWith(entreprise_17, "P"), TRUE, FALSE),
         ULI = ifelse(startsWith(entreprise_17, "P"), FALSE, TRUE))
  

# Merge with SIRUS -------------------------------------------------------------
cam_sirus <- merge(sirus17 %>% rename(entreprise_17=sirus_id), 
                   cam_recup, 
                   by.x = "entreprise_17", by.y = "entreprise_17", all.y = TRUE)

### Remove duplicates (only one EP17)
cam_sirus <- distinct(cam_sirus, entreprise_17, .keep_all = TRUE)

# Final table -----------------------------------------------------------------
table_out_finale <- merge(cam_sirus %>% dplyr::select(entreprise_17, entreprise_20, ape, creat_daaaammjj, nbet_a, eff_3112, eff_etp, ca, total_bilan), 
                          table_aggr_EP_UL, 
                          by.x = "entreprise_17", by.y = "entreprise_17", all.y = TRUE, all.x=TRUE)

# We add back survey answers
table_out_finale <- merge(table_out_finale, (cam %>% select(-c("EP", "ULI"))), by.x = "entreprise_20", by.y = "entreprise_20", all.y = TRUE) 

# We filter out 0 VA and 0 employment
table_out_finale <- table_out_finale %>%
  mutate(keep = ifelse(eqtp == 0 | vacf == 0 | wage_brut == 0, FALSE, TRUE))

# Custom variables
table_out_finale <- table_out_finale %>%
  mutate(VA_L  = ifelse(eqtp != 0, vacf / eqtp, NA),
         W_L = ifelse(eqtp != 0, wage_brut / eqtp, NA),
         K_L = ifelse(eqtp != 0, K / eqtp, NA),
         inge_wage_frac = ifelse(wage_brut != 0, wage_brut_inge/wage_brut, NA),
         RD_wage_frac = ifelse(wage_brut != 0, wage_brut_RD/wage_brut, NA),
         HS_wage_frac = ifelse(wage_brut != 0, wage_brut_HS/wage_brut, NA),
         techies_wage_frac = ifelse(wage_brut != 0, wage_brut_techies/wage_brut, NA),
         inge_eqtp_frac = ifelse(eqtp != 0, eqtp_inge/eqtp, NA),
         RD_eqtp_frac = ifelse(eqtp != 0, eqtp_RD/eqtp, NA),
         HS_eqtp_frac = ifelse(eqtp != 0, eqtp_HS/eqtp, NA),
         techies_eqtp_frac = ifelse(eqtp != 0, eqtp_techies/eqtp, NA),
         inge_nb_heures_frac = ifelse(nb_heures != 0, nb_heures_inge/nb_heures, NA),
         RD_nb_heures_frac = ifelse(nb_heures != 0, nb_heures_RD/nb_heures, NA),
         HS_nb_heures_frac = ifelse(nb_heures != 0, nb_heures_HS/nb_heures, NA),
         techies_nb_heures_frac = ifelse(nb_heures != 0, nb_heures_techies/nb_heures, NA)
  )

# Save -------------------------------------------------------------------------
write_rds(table_out_finale, paste0(data_path, "out/2_final/cam_augmented.rds"))
