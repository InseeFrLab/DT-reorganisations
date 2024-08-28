#===============================================================================
# This code create datasets at various levels for regressions
#===============================================================================


# Input data and formatting -----------------------------------------------------
table_regression <- read_rds(paste0(data_path, "out/2_final/cam_augmented.rds"))

## Restrict sample to usable observations --------------------------------------
# Remove firms with missing covariates
table_regression <- table_regression %>% filter(!(is.na(table_regression$vacf)) & !(table_regression$vacf<=0) &                             
                                                  !(is.na(table_regression$K)) & !(table_regression$K<=0) &                            
                                                  !(is.na(table_regression$eqtp)) & !(table_regression$eqtp<=0) &
                                                  !(is.na(table_regression$ACHAT_BIEN)))

# Remove firms with missing information on boundary changes
table_regression <- table_regression %>% filter(DELOC!=4 & RELOC!= 4)

# Remove firms in construction industry
table_regression <- table_regression %>% filter(DOMAINE != 2)


## Variables in log ------------------------------------------------------------
variables_to_use <- c("vacf", "W_L", "K_L", "VA_L",
                      "L_fare", "eqtp")

table_regression[, paste0("log_", variables_to_use)] <- lapply(variables_to_use, function(x) log(table_regression[[x]]))

## Create various offshoring/reshoring variables  ------------------------------
cores <- c("IND", "CONS", "TRP", "COM", "SI", "ADMIN", "ING", "RD", "AUTRE")

deloc_grp_vars <- paste0("DELOC_", cores, "_GRP")
deloc_indep_vars <- paste0("DELOC_", cores, "_INDEP")
reloc_grp_vars <- paste0("RELOC_", cores, "_GRP")
reloc_indep_vars <- paste0("RELOC_", cores, "_INDEP")

table_regression <- table_regression %>%
  mutate(DELOC_ou_RELOC_ou_EXTERN = ifelse(DELOC == 1 | RELOC == 1, 1, 0),
         DELOC_ou_RELOC = ifelse(DELOC == 1 | RELOC == 1, TRUE, FALSE),
         
         DELOC= ifelse(DELOC == 1, 1, 0),
         RELOC= ifelse(RELOC == 1, 1, 0),
         
         DELOC_INTRA = ifelse(across(all_of(deloc_grp_vars), ~ .x == 1) %>% rowSums() > 0, 1, 0),
         DELOC_EXTRA = ifelse(across(all_of(deloc_indep_vars), ~ .x == 1) %>% rowSums() > 0, 1, 0),
         RELOC_INTRA = ifelse(across(all_of(reloc_grp_vars), ~ .x == 1) %>% rowSums() > 0, 1, 0),
         RELOC_EXTRA = ifelse(across(all_of(reloc_indep_vars), ~ .x == 1) %>% rowSums() > 0, 1, 0)
  )

## Ownership -------------------------------------------------------------------  
table_regression <- table_regression %>%
  mutate(GEE = ifelse(TYPE_UNITE=="GEE",1,0 ),
         GEF = ifelse(TYPE_UNITE=="GEF",1,0 ),
         GFR = ifelse(TYPE_UNITE=="GFR",1,0 ),
         TYPE_ENT= ifelse(TYPE_UNITE=="ULI" , 0 ,ifelse(TYPE_UNITE=="GEF",2,ifelse(TYPE_UNITE=="GEE",1, ifelse(TYPE_UNITE=="GFR",3,"ERR")))),
         TYPE_ENT_grp= ifelse(TYPE_UNITE=="ULI" |TYPE_UNITE=="GFR", 0 ,ifelse(TYPE_UNITE=="GEF",2,ifelse(TYPE_UNITE=="GEE",1,"ERR"))),
         ULI_GFR = ifelse(TYPE_UNITE=="GFR" |TYPE_UNITE=="ULI",1,0 ),
  )

## Sector ----------------------------------------------------------------------
table_regression <- table_regression %>%
  mutate(CORE = case_when(DOMAINE == 1 ~ "IND", DOMAINE == 2 ~ "CONS", 
                          DOMAINE == 3 ~ "TRP", DOMAINE == 4 ~ "COM", 
                          DOMAINE == 5 ~ "ITC", DOMAINE == 6 ~ "SAF",
                          DOMAINE == 7 ~ "ING", DOMAINE == 8 ~ "RD",
                          DOMAINE == 9 ~ "AUTRE"),
         
         IND = ifelse(DOMAINE == 1, 1, 0),
         CONS = ifelse(DOMAINE == 2, 1, 0),
         TRP = ifelse(DOMAINE == 3, 1, 0), 
         COM = ifelse(DOMAINE == 4, 1, 0), 
         ITC = ifelse(DOMAINE == 5, 1, 0), 
         SAF = ifelse(DOMAINE == 6, 1, 0), 
         ING = ifelse(DOMAINE == 7, 1, 0), 
         RD = ifelse(DOMAINE == 8, 1, 0), 
         AUTRE = ifelse(DOMAINE == 9, 1, 0), 
  )



# Who --------------------------------------------------------------------------
regdata_who <- table_regression %>% select_if(~!is.list(.))
haven::write_dta(regdata_who, path = paste0(data_path, "out/1_intermediary/regdata_who.dta"))

# What -------------------------------------------------------------------------
## Dataset at the firm X business function level -------------------------------
table_long_deloc <- reshape(table_regression%>%
                              select(c("DELOC_IND","DELOC_TRP", "DELOC_COM", "DELOC_SI","DELOC_ADMIN", "DELOC_ING", "DELOC_RD", "DELOC_AUTRE","entreprise_17")) %>%
                              mutate_at(vars(-entreprise_17),funs(case_when(is.na(.) ~ 0, .==1 ~ 1, .==2 ~ 1, .==3 ~ 0,.==0 ~ 0 ))), 
                            direction="long", 
                            varying=c("DELOC_IND","DELOC_TRP", "DELOC_COM", "DELOC_SI","DELOC_ADMIN", "DELOC_ING", "DELOC_RD", "DELOC_AUTRE"),sep="_") %>% 
  select(-id)



table_long_deloc_grp <- reshape(table_regression%>%
                                  select(c("DELOC_IND_GRP","DELOC_TRP_GRP", "DELOC_COM_GRP", "DELOC_SI_GRP","DELOC_ADMIN_GRP", "DELOC_ING_GRP", "DELOC_RD_GRP", "DELOC_AUTRE_GRP","entreprise_17")) %>%
                                  rename_with(~str_remove(., '_GRP'))%>%
                                  mutate_at(vars(-entreprise_17),funs(case_when(is.na(.) ~ 0, .==1 ~ 1, .==".o"~0,.==0 ~ 0 ))), 
                                direction="long", 
                                varying=c("DELOC_IND","DELOC_TRP", "DELOC_COM", "DELOC_SI","DELOC_ADMIN", "DELOC_ING", "DELOC_RD", "DELOC_AUTRE"),sep="_") %>%
  rename("DELOC_INTRA"="DELOC") %>% select(-id)



table_long_deloc_indep <- reshape(table_regression%>%
                                    select(c("DELOC_IND_INDEP","DELOC_TRP_INDEP", "DELOC_COM_INDEP", "DELOC_SI_INDEP","DELOC_ADMIN_INDEP", "DELOC_ING_INDEP", "DELOC_RD_INDEP", "DELOC_AUTRE_INDEP","entreprise_17")) %>%
                                    rename_with(~str_remove(., '_INDEP'))%>%
                                    mutate_at(vars(-entreprise_17),funs(case_when(is.na(.) ~ 0, .==1 ~ 1, .==".o"~0,.==0 ~ 0 ))), 
                                  direction="long", 
                                  varying=c("DELOC_IND","DELOC_TRP", "DELOC_COM", "DELOC_SI","DELOC_ADMIN", "DELOC_ING", "DELOC_RD", "DELOC_AUTRE"),sep="_") %>% 
  rename("DELOC_EXTRA"="DELOC") %>% select(-id)

table_long_reloc <- reshape(table_regression%>%
                              select(c("RELOC_IND","RELOC_TRP", "RELOC_COM", "RELOC_SI","RELOC_ADMIN", "RELOC_ING", "RELOC_RD", "RELOC_AUTRE","entreprise_17"))%>%
                              mutate_at(vars(-entreprise_17),funs(case_when(is.na(.) ~ 0, .==1 ~ 1, .==2 ~ 1, .==3 ~ 0,.==0 ~ 0 ))), 
                            direction="long", 
                            varying=c("RELOC_IND","RELOC_TRP", "RELOC_COM", "RELOC_SI","RELOC_ADMIN", "RELOC_ING", "RELOC_RD", "RELOC_AUTRE"),sep="_") %>% 
  select(-id)

table_long_reloc_grp <- reshape(table_regression%>%
                                  select(c("RELOC_IND_GRP","RELOC_TRP_GRP", "RELOC_COM_GRP", "RELOC_SI_GRP","RELOC_ADMIN_GRP", "RELOC_ING_GRP", "RELOC_RD_GRP", "RELOC_AUTRE_GRP","entreprise_17")) %>%
                                  rename_with(~str_remove(., '_GRP'))%>%
                                  mutate_at(vars(-entreprise_17),funs(case_when(is.na(.) ~ 0, .==1 ~ 1, .==".o"~0,.==0 ~ 0 ))), 
                                direction="long", 
                                varying=c("RELOC_IND","RELOC_TRP", "RELOC_COM", "RELOC_SI","RELOC_ADMIN", "RELOC_ING", "RELOC_RD", "RELOC_AUTRE"),sep="_") %>%
  rename("RELOC_INTRA"="RELOC") %>% select(-id)


table_long_reloc_indep <- reshape(table_regression%>%
                                    select(c("RELOC_IND_INDEP","RELOC_TRP_INDEP", "RELOC_COM_INDEP", "RELOC_SI_INDEP","RELOC_ADMIN_INDEP", "RELOC_ING_INDEP", "RELOC_RD_INDEP", "RELOC_AUTRE_INDEP","entreprise_17")) %>%
                                    rename_with(~str_remove(., '_INDEP'))%>%
                                    mutate_at(vars(-entreprise_17),funs(case_when(is.na(.) ~ 0, .==1 ~ 1, .==".o"~0,.==0 ~ 0 ))), 
                                  direction="long", 
                                  varying=c("RELOC_IND","RELOC_TRP", "RELOC_COM", "RELOC_SI","RELOC_ADMIN", "RELOC_ING", "RELOC_RD", "RELOC_AUTRE"),sep="_") %>% 
  rename("RELOC_EXTRA"="RELOC") %>% select(-id)


table_deloc_reloc <- merge(merge(merge(merge(merge(table_long_deloc, table_long_deloc_grp, by=c("entreprise_17", "time"))
                                             , table_long_deloc_indep, by=c("entreprise_17", "time"))
                                       , table_long_reloc, by=c("entreprise_17", "time"))
                                 , table_long_reloc_grp, by=c("entreprise_17", "time"))
                           , table_long_reloc_indep, by=c("entreprise_17", "time")) %>%
  rename("task"="time")

table_deloc_reloc_sum <- table_deloc_reloc %>% group_by(entreprise_17) %>%
  summarise(nb_deloc = sum(DELOC==1), nb_reloc = sum(RELOC),
            nb_deloc_intra = sum(DELOC_INTRA), nb_reloc_intra = sum(RELOC_INTRA),
            nb_deloc_extra = sum(DELOC_EXTRA), nb_reloc_extra = sum(RELOC_EXTRA))


table_deloc_reloc_sum$nb_mouvement <- table_deloc_reloc_sum$nb_deloc + table_deloc_reloc_sum$nb_reloc

## Factor content --------------------------------------------------------------
factor_content <- read_rds(paste0(data_path, "out/2_final/factor_content.rds"))

factor_content <- factor_content %>% rename_with(~ paste0("task_", .x))

factor_content <- factor_content %>%  mutate_if(is.numeric, funs(log = log(.)))

regdata_what <- merge(table_deloc_reloc, factor_content, by.x="task", by.y="task_secteur", all.x=TRUE)
regdata_what <- merge(table_regression %>% select(-c("DELOC", "DELOC_INTRA", "DELOC_EXTRA", "RELOC", "RELOC_INTRA", "RELOC_EXTRA", "DELOC_ou_RELOC")), regdata_what, by="entreprise_17", all.x= TRUE)
regdata_what <- regdata_what %>% mutate(DELOC_ou_RELOC = ifelse(DELOC == 1 | RELOC == 1, TRUE, FALSE))
regdata_what <- regdata_what %>% mutate(task_IND = ifelse(task == "IND", TRUE, FALSE))

regdata_what$task_is_core<-ifelse((regdata_what$DOMAINE==1 & regdata_what$task=="IND")  |(regdata_what$DOMAINE==3 & regdata_what$task=="TRP") |(regdata_what$DOMAINE==4 & regdata_what$task=="COM") |(regdata_what$DOMAINE==5 & regdata_what$task=="SI") |(regdata_what$DOMAINE==6 & regdata_what$task=="ADMIN") |(regdata_what$DOMAINE==7 & regdata_what$task=="ING") |(regdata_what$DOMAINE==8 & regdata_what$task=="RD") |(regdata_what$DOMAINE==9 & regdata_what$task=="AUTRE"),1,0 )

## Save as .dta ----------------------------------------------------------------
regdata_what <- regdata_what %>% select_if(~!is.list(.))
haven::write_dta(regdata_what, path = paste0(data_path, "out/1_intermediary/regdata_what.dta"))

# How --------------------------------------------------------------------------
## Dataset at the firm X business function X intra/extra level -----------------
regdata_how <- merge(table_deloc_reloc, table_deloc_reloc_sum%>%filter(nb_mouvement>=1), by = "entreprise_17", all.y=TRUE)
regdata_how <- merge(regdata_how, factor_content, by.x="task", by.y="task_secteur", all.x=TRUE)
regdata_how <- merge(table_regression %>% select(-c("DELOC","RELOC","DELOC_INTRA","DELOC_EXTRA","RELOC_INTRA","RELOC_EXTRA")), regdata_how, by="entreprise_17", all.y= TRUE)

regdata_how <- regdata_how %>%
  mutate(DELOC_INTRA_V_EXTRA = ifelse(DELOC_INTRA == 1 &  DELOC_EXTRA == 0, 1, 0),
         RELOC_INTRA_V_EXTRA = ifelse(RELOC_INTRA == 1 &  RELOC_EXTRA == 0, 1, 0),
         INTRA_V_EXTRA = ifelse((DELOC_INTRA == 1 | RELOC_INTRA == 1) & (DELOC ==1 | RELOC == 1), 1, 0)) 


regdata_how$task_is_core<-ifelse((regdata_how$DOMAINE==1 & regdata_how$task=="IND")  |(regdata_how$DOMAINE==3 & regdata_how$task=="TRP") |(regdata_how$DOMAINE==4 & regdata_how$task=="COM") |(regdata_how$DOMAINE==5 & regdata_how$task=="SI") |(regdata_how$DOMAINE==6 & regdata_how$task=="ADMIN") |(regdata_how$DOMAINE==7 & regdata_how$task=="ING") |(regdata_how$DOMAINE==8 & regdata_how$task=="RD") |(regdata_how$DOMAINE==9 & regdata_how$task=="AUTRE"),1,0 )

## Save as .dta ----------------------------------------------------------------
regdata_how <- regdata_how %>% select_if(~!is.list(.))
haven::write_dta(regdata_how, path = paste0(data_path, "out/1_intermediary/regdata_how.dta"))

# Where ------------------------------------------------------------------------
## Dataset at the firm X business function X destination level -----------------
regdata_where <- regdata_what %>%
  filter(DELOC == 1)%>%
  mutate( 
    DELOC_IND_aaRDM = ifelse(DELOC_IND_AMERIQ == 1 | DELOC_IND_AFRIQUE == 1 , 1, 0),
    DELOC_CONS_aaRDM = ifelse(DELOC_CONS_AMERIQ == 1 | DELOC_CONS_AFRIQUE == 1 , 1, 0),
    DELOC_TRP_aaRDM = ifelse(DELOC_TRP_AMERIQ == 1 | DELOC_TRP_AFRIQUE == 1 , 1, 0),
    DELOC_COM_aaRDM = ifelse(DELOC_COM_AMERIQ == 1 | DELOC_COM_AFRIQUE == 1 , 1, 0),
    DELOC_SI_aaRDM = ifelse(DELOC_SI_AMERIQ == 1 | DELOC_SI_AFRIQUE == 1 , 1, 0),
    DELOC_ADMIN_aaRDM = ifelse(DELOC_ADMIN_AMERIQ == 1 | DELOC_ADMIN_AFRIQUE == 1  , 1, 0),
    DELOC_ING_aaRDM = ifelse(DELOC_ING_AMERIQ == 1 | DELOC_ING_AFRIQUE == 1 , 1, 0),
    DELOC_RD_aaRDM = ifelse(DELOC_RD_AMERIQ == 1 | DELOC_RD_AFRIQUE == 1 , 1, 0),
    DELOC_AUTRE_aaRDM = ifelse(DELOC_AUTRE_AMERIQ == 1 | DELOC_AUTRE_AFRIQUE == 1 , 1, 0)
  )


## Create a dataframe for each destination and concatenate ---------------------
df_ue14 <- regdata_where %>% mutate(destination = "UE14")
df_ue13 <- regdata_where %>% mutate(destination = "UE13")
df_uk <- regdata_where %>% mutate(destination = "UK")
df_autre_ue <- regdata_where %>% mutate(destination = "EUR")
df_maghreb <- regdata_where %>% mutate(destination = "MAGHREB")
df_usa_canada <- regdata_where %>% mutate(destination = "USA")
df_RDM <- regdata_where %>% mutate(destination = "aaRDM")
df_chine <- regdata_where %>% mutate(destination = "CHINE")
df_inde <- regdata_where %>% mutate(destination = "INDE")
df_asie <- regdata_where %>% mutate(destination = "ASIE")

regdata_where <- bind_rows(df_ue14, df_ue13, df_uk, df_autre_ue, df_maghreb, 
                            df_usa_canada, df_RDM, df_chine, df_inde, df_asie)

regdata_where <- regdata_where %>%
  rowwise() %>%
  mutate(offshoring = ifelse(get(paste0("DELOC_", task, "_", destination)) == 1, 1, 0))

## Add destination data --------------------------------------------------------
destination_data <- fread(paste0(data_path, "out/2_final/destination_data.csv "))
regdata_where <- merge(regdata_where, destination_data, by.x = "destination", by.y = "Zone2", all.x= TRUE)

## Covariates ------------------------------------------------------------------
regdata_where <- regdata_where %>%
  mutate(
    task_RD_fracxlog_gdp_per_capita = task_RD_frac * log_gdp_per_capita,
  
    task_HS_fracxlog_gdp_per_capita= task_HS_frac * log_gdp_per_capita,
    
    task_is_corexlog_gdp_per_capita= task_is_core*log_gdp_per_capita,
    task_HS_fracxINDE = ifelse(destination == "INDE", task_HS_frac, 0),
    task_RD_fracxINDE = ifelse(destination == "INDE", task_RD_frac, 0)
  )
## Save as .dta ----------------------------------------------------------------
regdata_where <- regdata_where %>% select_if(~!is.list(.))
haven::write_dta(regdata_where, path = paste0(data_path, "out/1_intermediary/regdata_where.dta "))
