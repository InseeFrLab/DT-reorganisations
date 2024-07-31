#===============================================================================
# This code retrieves the set of legal units of surveyed firms in 2017
#===============================================================================

# Import data ------------------------------------

cam  <- setDT(read_rds(paste0(data_path, "out/2_final/base_cam_cleaned.rds"))) %>% 
  dplyr::select(sirus_id, EP, ULI, DOMAINE) %>%
  rename(entreprise_20 = sirus_id)

contour_2017 <- read_parquet(paste0(data_path, "out/1_intermediary/contour_17.parquet"))
contour_2020 <- read_parquet(paste0(data_path, "out/1_intermediary/contour_20.parquet"))

fare17 <- read_parquet(paste0(data_path, "out/1_intermediary/fare_17.parquet"))
fare20 <- read_parquet(paste0(data_path, "out/1_intermediary/fare_20.parquet"))

# Separate matched and unmatched EP --------------------------------------------
list_ep <- (cam %>% filter(EP))$entreprise_20
contour_2017_matched <- contour_2017 %>% filter(sirus_id %in% list_ep)
list_ep_match_cep17 <- unique(contour_2017_matched$sirus_id)
list_ep_not_match <- setdiff(list_ep, list_ep_match_cep17)

# Largest legal unit method ----------------------------------------------------
contour_2020_no17_cam <- contour_2020 %>%
  filter(sirus_id %in% list_ep_not_match) %>%
  mutate(siren = ifelse(nchar(siren) < 9, str_pad(siren, width = 9, pad = "0"), siren))

fare_2020_contour_cam <- merge(fare20, contour_2020_no17_cam, by.x = "siren", by.y = "siren") %>% 
  group_by(siren_ent) %>% 
  mutate(tot_empl = sum(redi_e200)) %>% 
  mutate(sh_empl = redi_e200/tot_empl) %>% 
  mutate(max_empl = max(sh_empl)) %>%
  ungroup() %>%
  mutate(largest_siren = sh_empl == max_empl)

# For 4 EP, 2 sirens have the same share of employment. We remove them.
fare_2020_contour_cam <- fare_2020_contour_cam %>% 
  filter(largest_siren) %>% 
  select(siren_ent, siren) %>%
  group_by(siren_ent) %>%
  mutate(nb = n()) %>%
  filter(nb == 1) %>%
  select(-nb)

# We retrieve the EP in 2017 of the largest siren
fare_2017_largest_siren <-  fare17 %>%
  filter(siren %in% fare_2020_contour_cam$siren) %>%
  select(c("siren", "id_groupe", "id_tg", "siren_ent"))

# Some were not in a EP nor in a group. We collect them as single legal units
list_largest_siren_noep_17 <- fare_2017_largest_siren %>% filter(id_tg == "" & siren_ent == "") %>% select(siren) %>% mutate(uli17_mlargest = TRUE)

list_largest_siren_ep_17 <- fare_2017_largest_siren %>% filter(siren_ent != "") %>% select(siren, siren_ent) %>% rename(EP_17 = siren_ent) 


# Group head method ------------------------------------------------------------
fare_2020_cam <- fare20 %>% filter(siren_ent %in% list_ep_not_match)
list_head <- unique(fare_2020_cam %>% select(id_groupe, id_tg, siren_ent))
# Some EP are not linked to any group
list_head <- list_head %>% filter(id_groupe != "")
# Some EP belong in several groups
list_head <- list_head %>% group_by(siren_ent) %>% mutate(nb_grp = n()) %>% ungroup()
# Some groups encase multiple EP
list_head <- list_head %>% group_by(id_groupe) %>% mutate(nb_ep = n()) %>% ungroup()
# We keep EP-groups with a unique correspondance
list_head <- list_head %>% filter(nb_grp == 1 & nb_ep == 1)

# Using the group head identifier, we retrieve the identifier of the EP in 2017 and keep the unique correspondances
fare_2017_tg20 <- fare17 %>% filter(id_tg %in% list_head$id_tg)
list_head_17 <- unique(fare_2017_tg20 %>% select(id_groupe, id_tg, siren_ent))
# Some group heads are associated with missing EP
list_head_17 <- list_head_17 %>% filter(siren_ent != "")

# We recover those that were EP in 2017
list_head_17 <- list_head_17 %>% group_by(siren_ent) %>% mutate(nb_grp = n()) %>% ungroup()
list_head_17 <- list_head_17 %>% group_by(id_groupe) %>% mutate(nb_ep = n()) %>% ungroup()

list_ep_tete_17 <- list_head_17 %>% filter(nb_ep == 1 & nb_grp ==1) %>% select(id_tg, siren_ent) %>% rename(EP_17 = siren_ent) %>% mutate(uli17 = FALSE, tg_17 = TRUE)

# We recover those that were single legal units in 2017: possible for French group heads
list_head <- list_head %>% mutate(foreign = grepl("^[A-Z]", id_tg))
list_head20_notete_17 <- setdiff(unique((list_head %>% filter(foreign == 0))$id_tg),  unique(fare_2017_tg20$id_tg))

fare_2017_tg20_uli <-  fare17 %>%
  filter(siren %in% list_head20_notete_17) %>%
  select(c("siren", "id_groupe", "id_tg", "siren_ent")) %>% 
  mutate(siren_est_tg = siren == id_tg)

list_uli_17 <- fare_2017_tg20_uli %>% filter(id_tg == "" & siren_ent == "") %>% select(siren) %>% rename(id_tg = siren) %>% mutate(uli17 = TRUE, tg_17 = FALSE)

# Some of those belonged to an EP
list_ep_notete_17 <- fare_2017_tg20_uli %>% filter(siren_ent != "") %>% select(siren, siren_ent) %>% rename(id_tg = siren, EP_17 = siren_ent) %>% mutate(uli17 = FALSE, tg_17 = FALSE)

## Correspondance
corresp_ep_ep <- merge(list_head %>% select(id_tg, siren_ent) %>% rename(EP_20 = siren_ent), rbind(list_ep_tete_17, list_ep_notete_17), by.x = "id_tg", by.y = "id_tg")
corresp_ep_uli <- merge(list_head %>% select(id_tg, siren_ent) %>% rename(EP_20 = siren_ent), list_uli_17, by.x = "id_tg", by.y = "id_tg")


# Combine results of the two methods -------------------------------------------

# Largest unit
recap_mlargest <- unique(merge(contour_2020_no17_cam %>% select(sirus_id), fare_2020_contour_cam, by.x = "sirus_id", by.y = "siren_ent", all.x = TRUE))

recap_mlargest <- merge(recap_mlargest, list_largest_siren_noep_17, by.x = "siren", by.y = "siren", all.x = TRUE)
recap_mlargest$uli17_mlargest <- ifelse(is.na(recap_mlargest$uli17_mlargest), 0, 1)
recap_mlargest <- merge(recap_mlargest, list_largest_siren_ep_17, by.x = "siren", by.y = "siren", all.x = TRUE)
recap_mlargest$ep17_mlargest <- ifelse(is.na(recap_mlargest$EP_17), 0, 1)

recap_mlargest$entreprise_17_mlargest <- ifelse(recap_mlargest$uli17_mlargest, recap_mlargest$siren, ifelse(recap_mlargest$ep17_mlargest, recap_mlargest$EP_17, NA))
recap_mlargest <- recap_mlargest %>% rename(entreprise_20 = sirus_id) %>% select(c("entreprise_20" ,"entreprise_17_mlargest", "uli17_mlargest", "ep17_mlargest"))

# Group head
recap_mtg <- unique(merge(contour_2020_no17_cam  %>% select(sirus_id), corresp_ep_uli %>% select(c("id_tg", "EP_20", "uli17")), by.x = "sirus_id", by.y = "EP_20", all.x = TRUE))
recap_mtg$uli17_mtg <- ifelse(is.na(recap_mtg$uli17), 0, 1)
recap_mtg <- recap_mtg %>% rename(siren_17 = id_tg)

recap_mtg <- merge(recap_mtg, corresp_ep_ep %>% select(c("EP_17", "EP_20")), by.x = "sirus_id", by.y = "EP_20", all.x = TRUE)
recap_mtg$ep17_mtg <- ifelse(is.na(recap_mtg$EP_17), 0, 1)

recap_mtg$entreprise_17_mtg <- ifelse(recap_mtg$uli17_mtg, recap_mtg$siren_17, ifelse(recap_mtg$ep17_mtg, recap_mtg$EP_17, NA))

recap_mtg <- recap_mtg %>% rename(entreprise_20 = sirus_id) %>% select(c("entreprise_20" ,"entreprise_17_mtg", "uli17_mtg", "ep17_mtg"))

# Combine
comparaison <- merge(recap_mlargest, recap_mtg, by = "entreprise_20", all = TRUE)

# Save
write_rds(comparaison, paste0(data_path, "out/1_intermediary/cam_ep17.rds"))
