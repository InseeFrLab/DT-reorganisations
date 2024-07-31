#===============================================================================
# This code builds the working data from the CAM survey
#===============================================================================

cam_5 <- readRDS(paste0(cam_path, "cam_5.rds"))

# Keep usable firms  
base_cam_cleaned<- cam_5 %>% filter(EXPLOI=="TRUE")


# Select variables of interest
base_cam_cleaned<-subset(base_cam_cleaned,select=c("SIRUS_ID","NUMPOIDS","TYPE_SOC_FIN","TYPE_UNITE", "COEUR_METIER",
                                                   "GROUP_ACHAT","GROUP_VENTE",
                                                   
                                                   "ACHAT_BIEN", "ACHAT_SERVICE", "VTE_BIEN", "VTE_SERV",
                                                   
                                                   "DELOC",
                                                   "DELOC_IND","DELOC_CONS","DELOC_TRP","DELOC_COM","DELOC_SI","DELOC_ADMIN","DELOC_ING","DELOC_RD","DELOC_AUTRE",
                                                   "DELOC_IND_GRP", "DELOC_CONS_GRP", "DELOC_TRP_GRP", "DELOC_COM_GRP", "DELOC_SI_GRP", "DELOC_ADMIN_GRP", "DELOC_ING_GRP", "DELOC_RD_GRP", "DELOC_AUTRE_GRP",
                                                   "DELOC_IND_INDEP","DELOC_CONS_INDEP","DELOC_TRP_INDEP","DELOC_COM_INDEP","DELOC_SI_INDEP","DELOC_ADMIN_INDEP","DELOC_ING_INDEP","DELOC_RD_INDEP","DELOC_AUTRE_INDEP",
                                                   "DELOC_IND_UE14","DELOC_IND_UE13","DELOC_IND_UK","DELOC_IND_EUR","DELOC_IND_CHINE","DELOC_IND_INDE","DELOC_IND_ASIE","DELOC_IND_USA","DELOC_IND_AMERIQ","DELOC_IND_MAGHREB","DELOC_IND_AFRIQUE","DELOC_IND_SO","DELOC_IND_NSP",
                                                   "DELOC_CONS_UE14","DELOC_CONS_UE13","DELOC_CONS_UK","DELOC_CONS_EUR","DELOC_CONS_CHINE","DELOC_CONS_INDE","DELOC_CONS_ASIE","DELOC_CONS_USA","DELOC_CONS_AMERIQ","DELOC_CONS_MAGHREB","DELOC_CONS_AFRIQUE","DELOC_CONS_SO","DELOC_CONS_NSP",
                                                   "DELOC_TRP_UE14","DELOC_TRP_UE13","DELOC_TRP_UK","DELOC_TRP_EUR","DELOC_TRP_CHINE","DELOC_TRP_INDE","DELOC_TRP_ASIE","DELOC_TRP_USA","DELOC_TRP_AMERIQ","DELOC_TRP_MAGHREB","DELOC_TRP_AFRIQUE","DELOC_TRP_SO","DELOC_TRP_NSP",
                                                   "DELOC_COM_UE14","DELOC_COM_UE13","DELOC_COM_UK","DELOC_COM_EUR","DELOC_COM_CHINE","DELOC_COM_INDE","DELOC_COM_ASIE","DELOC_COM_USA","DELOC_COM_AMERIQ","DELOC_COM_MAGHREB","DELOC_COM_AFRIQUE","DELOC_COM_SO","DELOC_COM_NSP",
                                                   "DELOC_SI_UE14","DELOC_SI_UE13","DELOC_SI_UK","DELOC_SI_EUR","DELOC_SI_CHINE","DELOC_SI_INDE","DELOC_SI_ASIE","DELOC_SI_USA","DELOC_SI_AMERIQ","DELOC_SI_MAGHREB","DELOC_SI_AFRIQUE","DELOC_SI_SO","DELOC_SI_NSP",
                                                   "DELOC_ADMIN_UE14","DELOC_ADMIN_UE13","DELOC_ADMIN_UK","DELOC_ADMIN_EUR","DELOC_ADMIN_CHINE","DELOC_ADMIN_INDE","DELOC_ADMIN_ASIE","DELOC_ADMIN_USA","DELOC_ADMIN_AMERIQ","DELOC_ADMIN_MAGHREB","DELOC_ADMIN_AFRIQUE","DELOC_ADMIN_SO","DELOC_ADMIN_NSP",
                                                   "DELOC_ING_UE14","DELOC_ING_UE13","DELOC_ING_UK","DELOC_ING_EUR","DELOC_ING_CHINE","DELOC_ING_INDE","DELOC_ING_ASIE","DELOC_ING_USA","DELOC_ING_AMERIQ","DELOC_ING_MAGHREB","DELOC_ING_AFRIQUE","DELOC_ING_SO","DELOC_ING_NSP",
                                                   "DELOC_RD_UE14","DELOC_RD_UE13","DELOC_RD_UK","DELOC_RD_EUR","DELOC_RD_CHINE","DELOC_RD_INDE","DELOC_RD_ASIE","DELOC_RD_USA","DELOC_RD_AMERIQ","DELOC_RD_MAGHREB","DELOC_RD_AFRIQUE","DELOC_RD_SO","DELOC_RD_NSP",
                                                   "DELOC_AUTRE_UE14","DELOC_AUTRE_UE13","DELOC_AUTRE_UK","DELOC_AUTRE_EUR","DELOC_AUTRE_CHINE","DELOC_AUTRE_INDE","DELOC_AUTRE_ASIE","DELOC_AUTRE_USA","DELOC_AUTRE_AMERIQ","DELOC_AUTRE_MAGHREB","DELOC_AUTRE_AFRIQUE","DELOC_AUTRE_SO","DELOC_AUTRE_NSP",
                                                   
                                                   "DELOC_AVT2018", "DELOC_ST",
                                                  
                                                   "RELOC",
                                                   "RELOC_IND","RELOC_CONS","RELOC_TRP","RELOC_COM","RELOC_SI","RELOC_ADMIN","RELOC_ING","RELOC_RD","RELOC_AUTRE",
                                                   "RELOC_IND_GRP", "RELOC_IND_INDEP", 
                                                   "RELOC_CONS_GRP", "RELOC_CONS_INDEP", 
                                                   "RELOC_TRP_GRP", "RELOC_TRP_INDEP", 
                                                   "RELOC_COM_GRP", "RELOC_COM_INDEP", 
                                                   "RELOC_SI_GRP", "RELOC_SI_INDEP", 
                                                   "RELOC_ADMIN_GRP", "RELOC_ADMIN_INDEP", 
                                                   "RELOC_ING_GRP", "RELOC_ING_INDEP", 
                                                   "RELOC_RD_GRP", "RELOC_RD_INDEP", 
                                                   "RELOC_AUTRE_GRP", "RELOC_AUTRE_INDEP",
                                                   "RELOC_AVT2018",
                                                   "EFF_TOT",
                                                   
                                                   "SIREN_1_1", "SIREN_2_1", "SIREN_3_1", "SIREN_4_1", "SIREN_5_1", "SIREN_6_1", "SIREN_7_1", "SIREN_8_1", "SIREN_9_1", "SIREN_10_1",
                                                   "SIREN_UL_1_2", "SIREN_UL_2_2", "SIREN_UL_3_2", "SIREN_UL_4_2", "SIREN_UL_5_2", "SIREN_UL_6_2", "SIREN_UL_7_2", "SIREN_UL_8_2", "SIREN_UL_9_2", "SIREN_UL_10_2", 
                                                   "SIREN_ULINC_1_3", "SIREN_ULINC_2_3", "SIREN_ULINC_3_3", "SIREN_ULINC_4_3", "SIREN_ULINC_5_3", "SIREN_ULINC_6_3", "SIREN_ULINC_7_3", "SIREN_ULINC_8_3", "SIREN_ULINC_9_3", "SIREN_ULINC_10_3",
                                                   "SIREN_UL_SUP_1_1", "SIREN_UL_SUP_2_1", "SIREN_UL_SUP_3_1", "SIREN_UL_SUP_4_1", "SIREN_UL_SUP_5_1", "SIREN_UL_SUP_6_1", "SIREN_UL_SUP_7_1", "SIREN_UL_SUP_8_1", "SIREN_UL_SUP_9_1", "SIREN_UL_SUP_10_1"
))




# Recode core business
base_cam_cleaned$DOMAINE<-base_cam_cleaned$COEUR_METIER



base_cam_cleaned$DOMAINE_TEXT <- ifelse(base_cam_cleaned$DOMAINE==1,"Industrie",
                                        ifelse(base_cam_cleaned$DOMAINE==2,"Construction",
                                               ifelse(base_cam_cleaned$DOMAINE==3,"Transport et logistique",
                                                      ifelse(base_cam_cleaned$DOMAINE==4,"Commerce, marketing, services après-ventes",
                                                             ifelse(base_cam_cleaned$DOMAINE==5,"Services informatiques, technologies de l'information",
                                                                    ifelse(base_cam_cleaned$DOMAINE==6,"Services administratifs et financiers (ressources humaines, comptabilité et services juridiques, gestion des achats, etc.)",
                                                                           ifelse(base_cam_cleaned$DOMAINE==7,"Ingénierie et services techniques / conception",
                                                                                  ifelse(base_cam_cleaned$DOMAINE==8,"R&D",
                                                                                         ifelse(base_cam_cleaned$DOMAINE==9,"Autre",base_cam_cleaned$DOMAINE)))))))))  

# Recode firm type
base_cam_cleaned$TYPE<- base_cam_cleaned$TYPE_SOC_FIN 

base_cam_cleaned$TYPE_TEXT <- ifelse(base_cam_cleaned$TYPE_SOC_FIN==1,"Filiale d’un groupe international",
                                     ifelse(base_cam_cleaned$TYPE_SOC_FIN==2,"Filiale d’un groupe installé uniquement en France",
                                            ifelse(base_cam_cleaned$TYPE_SOC_FIN==3,"Société-mère d’un groupe international",
                                                   ifelse(base_cam_cleaned$TYPE_SOC_FIN==4,"Société-mère d’un groupe installé uniquement en France",
                                                          ifelse(base_cam_cleaned$TYPE_SOC_FIN==5,"Société indépendante",
                                                                 base_cam_cleaned$TYPE_SOC_FIN))))) 

base_cam_cleaned$TYPE_UNITE_TEXT<- dplyr::recode(base_cam_cleaned$TYPE_UNITE, `ULI` = "Unité légale indépendante", `GFR` = "Groupe franco-français ", `GEF` = "Multinationale sous contrôle français", 'GEE'="Multinationale sous contrôle étranger")

# Recode size group
base_cam_cleaned <- base_cam_cleaned %>%
  mutate(EFF_GROUPED = cut(EFF_TOT, 
                           breaks = c(0, 20, 50, 250, Inf), 
                           labels = c("0-20", "20-50", "50-250", "250+"), 
                           right = FALSE)) #Variable exhaustive !

# Recode within/outside the firm variables: 0 if no answer
list_to_recode <- c("RELOC_IND_GRP", "RELOC_IND_INDEP", "RELOC_CONS_GRP", "RELOC_CONS_INDEP", "RELOC_TRP_GRP", "RELOC_TRP_INDEP", 
                    "RELOC_COM_GRP", "RELOC_COM_INDEP", "RELOC_SI_GRP", "RELOC_SI_INDEP", 
                    "RELOC_ADMIN_GRP", "RELOC_ADMIN_INDEP", "RELOC_ING_GRP", "RELOC_ING_INDEP", 
                    "RELOC_RD_GRP", "RELOC_RD_INDEP", "RELOC_AUTRE_GRP", "RELOC_AUTRE_INDEP")
recodage_reloc <- function(X) {
  return(ifelse(base_cam_cleaned$RELOC != 1 | is.na(X), 0, X))
}
base_cam_cleaned[list_to_recode] <- lapply(base_cam_cleaned[list_to_recode], FUN = recodage_reloc) 

list_to_recode <- c("DELOC_IND_GRP", "DELOC_CONS_GRP", "DELOC_TRP_GRP", "DELOC_COM_GRP", "DELOC_SI_GRP",
                    "DELOC_ADMIN_GRP", "DELOC_ING_GRP", "DELOC_RD_GRP", "DELOC_AUTRE_GRP", 
                    "DELOC_IND_INDEP", "DELOC_CONS_INDEP", "DELOC_TRP_INDEP","DELOC_COM_INDEP","DELOC_SI_INDEP",
                    "DELOC_ADMIN_INDEP","DELOC_ING_INDEP","DELOC_RD_INDEP","DELOC_AUTRE_INDEP")
recodage_deloc <- function(X) {
  return(ifelse(base_cam_cleaned$DELOC != 1 | is.na(X), 0, X))
}
base_cam_cleaned[list_to_recode] <- lapply(base_cam_cleaned[list_to_recode], FUN = recodage_deloc) 

# Variables for EP/ULI
base_cam_cleaned <- base_cam_cleaned %>% mutate(EP = startsWith(base_cam_cleaned$SIRUS_ID, "P"))
base_cam_cleaned <- base_cam_cleaned %>% mutate(ULI = !startsWith(base_cam_cleaned$SIRUS_ID, "P"))
base_cam_cleaned <- rename(base_cam_cleaned,sirus_id=SIRUS_ID)

write_rds(base_cam_cleaned,paste0(data_path, "out/2_final/base_cam_cleaned.rds"))
