
# Aggregate number of offshorings and reshorings, weighted ------------------

regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))

boundary_changes <- regdata_who %>%
  filter(DELOC!=4 & RELOC!= 4 & keep == 1) %>%
  summarise(at_least_one =  weighted.mean(DELOC==1 | RELOC == 1, NUMPOIDS, na.rm=TRUE),
             Offshoring =  weighted.mean(DELOC==1, NUMPOIDS, na.rm=TRUE),
            Reshoring =  weighted.mean(RELOC==1, NUMPOIDS, na.rm=TRUE),
            Both = weighted.mean(DELOC==1 & RELOC==1, NUMPOIDS, na.rm=TRUE))
boundary_changes

# Share of manufacturing firms ---------------------------------------------------------------------

regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))
domaine_counts <- table_out_finale %>%
  filter(keep==1) %>%
  mutate(Code_NAF = substr(ape, 1, 2)) %>%
  mutate(industries = case_when(
    Code_NAF >= 10 & Code_NAF<=33 ~ "Manufacturing",
    Code_NAF >= 45 & Code_NAF<=47 ~ "Sales and Wholesale",
    Code_NAF >= 49 & Code_NAF<=53 ~ "Transport and Logistics",
    Code_NAF >= 69 & Code_NAF<=75 ~ "Engineering, R&D",
    Code_NAF >= 77 & Code_NAF<=82 ~ "Business services",
    .default = "Other"
  ))  %>%
  group_by(industries) %>%
  summarise(
    count = n()
  ) %>% 
  mutate(order = case_when(
    industries == "Manufacturing" ~ "1",
    industries == "Sales and Wholesale"~ "3",
    industries == "Engineering, R&D" ~ "5",
    industries == "Engineering, R&D" ~ "6",
    industries == "Business services" ~ "4",
    industries == "Transport and Logistics" ~ "2",
    .default = "7"
  )) %>% 
  arrange(order) %>%
  mutate(`Share` = `count` / sum(`count`)) %>%
  select(industries, count, Share)

domaine_counts <- rbind(domaine_counts, c("Total", unname(colSums(domaine_counts[, -1]))))

domaine_counts <- domaine_counts %>% mutate(Share = round(as.numeric(Share),3)*100 ) %>% mutate(`Share`=paste0(`Share`, "%"))
domaine_counts
# Share of multinationals ------------------------------------------------------

regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))
type_bis_counts <- regdata_who %>% 
  summarise(
    `Type de société` = c("Foreign MN (MNE)","Domestic MN (MNF)","French firm (GFF)","Independent French firm (ULI)"),
    `count` = c(
      sum(TYPE_UNITE == "GEE" , na.rm = TRUE),
      sum(TYPE_UNITE == "GEF", na.rm = TRUE),
      sum(TYPE_UNITE == "GFR" , na.rm = TRUE),
      sum(TYPE_UNITE == "ULI" , na.rm = TRUE))
    
  ) %>%  
  mutate(`Share` = `count` / sum(`count`))

type_bis_counts <- rbind(type_bis_counts, c("Total", unname(colSums(type_bis_counts[, -1]))))

type_bis_counts <- type_bis_counts %>% mutate(Share = round(as.numeric(Share),3)*100 ) %>% mutate(`Share`=paste0(`Share`, "%"))
type_bis_counts

# Correlation between share of high-skilled and routineness --------------------
stats_business_functions <- read_rds(paste0(data_path, "out/2_final/factor_content.rds"))
cor(stats_business_functions %>% select(avg_r_cog, HS_frac))

# Reorganised core business functions are less skill-intensive -----------------
regdata_what <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_what.dta"))
mean((regdata_what %>% filter(task_is_core == 1 & RELOC == 1))$task_HS_frac)
mean((regdata_what %>% filter(task_is_core == 0 & RELOC == 1))$task_HS_frac)
mean((regdata_what %>% filter(task_is_core == 1 & DELOC == 1))$task_HS_frac)
mean((regdata_what %>% filter(task_is_core == 0 & DELOC == 1))$task_HS_frac)

# Average number of offshoring per firm ----------------------------------------
regdata_where <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_where.dta"))
10*mean((regdata_where %>% filter(!is.na(offshoring)))$offshoring)

# Number of legal units by EP --------------------------------------------------
regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))
regdata_who <- regdata_who %>% filter(keep == 1, EP == 1) %>% 
  summarise(nb_ep = n(), avg_b_ul = mean(nb_ul), p10_ul = quantile(nb_ul, probs = 0.9), p50_ul = median(nb_ul))
regdata_who


# Statistics on matching EP17-EP20 ---------------------------------------------
cam_ep17 <- read_rds(paste0(data_path, "out/1_intermediary/cam_ep17.rds"))

### Nb of EP and UL with MLARGEST -----
table((cam_ep17 %>% filter(!is.na(entreprise_17_mlargest)))$ep17_mlargest )
### Nb of EP and UL with MTG ----
table((cam_ep17 %>% filter(!is.na(entreprise_17_mtg)))$ep17_mtg)

### Nb of recup EP, by type, by method -----------------------------------------
list_ep_recup <- cam_ep17 %>% 
  mutate(entreprise_17 =ifelse(is.na(entreprise_17_mlargest), entreprise_17_mtg, entreprise_17_mlargest),
         ep17 = ifelse(is.na(entreprise_17_mlargest), ep17_mtg, ep17_mlargest),
         uli17 = ifelse(is.na(entreprise_17_mlargest), uli17_mtg, uli17_mlargest),
         source = case_when(
           is.na(entreprise_17_mlargest) == FALSE ~ "mlargest",
           is.na(entreprise_17_mtg) == FALSE ~ "mtg",
           .default = "")) %>%
  select(c("entreprise_20", "entreprise_17", "uli17", "ep17", "source")) 
sum(!is.na(list_ep_recup$entreprise_17))
sum((list_ep_recup %>% filter(!is.na(list_ep_recup$entreprise_17)))$source=="mlargest")
sum((list_ep_recup$ep17))
sum((list_ep_recup$uli17))

# Alternative matching procedure for EP 20 - EP 17 -----------------------------
# Correspondence between an EP2020 and some EP2017 that share SIREN in common
# as the share of labor force in 2020 that is in the EP2017 

initial_correspondance <- read_rds(paste0(data_path, "out/1_intermediary/cam_ep17.rds"))

contour_2017 <- read_parquet(paste0(data_path, "out/1_intermediary/contour_17.parquet"))
contour_2020 <- read_parquet(paste0(data_path, "out/1_intermediary/contour_20.parquet"))

sirus17 <- read_parquet(paste0(data_path, "out/1_intermediary/sirus_17.parquet"))
sirus20 <- read_parquet(paste0(data_path, "out/1_intermediary/sirus_20.parquet"))

# Separate matched and unmatched EP
contour_2020_no17_cam <- contour_2020 %>%
  filter(sirus_id %in% initial_correspondance$entreprise_20) %>%
  mutate(siren = ifelse(nchar(siren) < 9, str_pad(siren, width = 9, pad = "0"), siren))

# Size of legal units of the contour in 2020
contour_2020_no17_sirus <- merge(contour_2020_no17_cam  %>% select(sirus_id, siren),
                                 sirus20 %>% rename(siren=sirus_id) %>% select(siren, eff_3112, eff_etp, ca), 
                                 by.x = "siren", by.y = "siren", all.x = TRUE)

contour_2020_no17_sirus <- contour_2020_no17_sirus %>% 
  group_by(sirus_id) %>% 
  mutate(largest_siren = max(ca, na.rm=TRUE), 
         is_largest_siren = ifelse(ca == largest_siren, 1, 0)) %>%
  ungroup()

# Size of legal units of the contour in 2017
contour_2017 <- contour_2017 %>%
  mutate(siren = ifelse(nchar(siren) < 9, str_pad(siren, width = 9, pad = "0"), siren))

contour_2017_sirus <- merge(contour_2017  %>% select(sirus_id, siren),
                            sirus17 %>% rename(siren=sirus_id) %>% select(siren, eff_3112, eff_etp, ca), 
                            by.x = "siren", by.y = "siren", all.x = TRUE)
# Correspondances
correspondance <- data.table(
  ep20 = character(),
  ep17 = character(),
  ca17_ep = numeric(),
  ca17_match = numeric(),
  ca20_match = numeric(),
  nb_siren_match = numeric(),
  nb_siren17_ep = numeric(),
  nb_siren20_ep = numeric(),
  contains_largest_siren = numeric()
)

for (ep20 in list_ep_not_match){
  # Collect the SIREN and size of SIREN of the EP
  list_siren <- (contour_2020_no17_sirus %>% filter(sirus_id == ep20) %>% select(siren, ca, is_largest_siren) %>% rename(ca20 = ca))
  # Flag where the SIREN are in 2017
  test <- contour_2017_sirus %>% mutate(siren_is_in = ifelse(siren %in% list_siren$siren, 1, 0))
  # Add the size variable in 2020
  test <- merge(test, list_siren, by.x = "siren", by.y = "siren", all.x = TRUE)
  # Fill NA size variables
  test$ca17 <- ifelse(is.na(test$ca17), 0 , test$ca17)
  # Weight the SIREN in the EPs they are in in 2017 and keep only those EPs
  test <- test %>% 
    group_by(sirus_id) %>% 
    summarise(ca17_ep = sum(ca), ca17_match = sum(ca*siren_is_in), ca20_match = sum(ca20*siren_is_in), nb_siren_match = sum(siren_is_in), nb_siren17_ep = n(), contains_largest_siren = sum(is_largest_siren, na.rm = TRUE)) %>% 
    filter(nb_siren_match != 0) %>%
    rename(ep17 = sirus_id)
  
  # Add ID of EP and number of SIREN in it
  test$ep20 <- ep20
  test$nb_siren20_ep <- length(unique(list_siren$siren))
  test <- test %>% select(ep20, ep17, ca17_ep, ca17_match, ca20_match, nb_siren_match, nb_siren17_ep, nb_siren20_ep, contains_largest_siren)
  correspondance <- rbind(correspondance, test) 
}
# We remove no_siren_match = 0 so if no EP17 existed for any of the SIREN of a EP20,
# then the EP20 is not in here

correspondance <- merge(correspondance, correspondance %>% group_by(ep20) %>% summarise(nb_ep_corres = n(), nb_siren_matched_ep = sum(nb_siren_match)), by.x = "ep20", by.y = "ep20")
correspondance <- correspondance %>% mutate(taux_recup_siren = nb_siren_matched_ep/nb_siren20_ep)
correspondance <- merge(correspondance, contour_2020_no17_sirus %>% group_by(sirus_id) %>% summarise(ca20_ep = sum(ca, na.rm = TRUE)) %>% rename(ep20 = sirus_id), by.x = "ep20", by.y = "ep20")
correspondance <- correspondance %>% mutate(taux_recup_ca = ca20_match/ca20_ep)

correspondance <- correspondance %>% mutate(selected = (nb_ep_corres<=3)*(contains_largest_siren == 1))
correspondance <- correspondance %>% rename(entreprise_17_mcorres = ep17)

# Table de la méthode mcorres
recap_mcorres <- unique((correspondance %>% filter(selected == 1) %>% select(c("entreprise_17_mcorres", "ep20"))))
recap_mcorres <- recap_mcorres %>% rename(entreprise_20 = ep20)

# Comparaison and figures
comparaison <- merge(initial_correspondance, recap_mcorres, by = "entreprise_20", all = TRUE)

# MLARGEST vs MCORRES
comparaison_both <- comparaison %>% filter((!is.na(comparaison$entreprise_17_mlargest) & !is.na(comparaison$entreprise_17_mcorres)))
table(comparaison_both$ep17_mlargest, comparaison_both$entreprise_17_mlargest == comparaison_both$entreprise_17_mcorres)
#--> all correspondance were already found using MLARGEST


