#===============================================================================
# Appendix Table 1: Number of reorganizing firms, reorganized business functions, integrated business functions 
# weighted and in the full sample
#===============================================================================

## Sample, Unweighted
regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))

boundary_changes <- regdata_who %>%
  filter(DELOC!=4 & RELOC!= 4 & keep == 1) %>%
  summarise(at_least_one =  mean(DELOC==1 | RELOC == 1, na.rm=TRUE),
            Offshoring =  mean(DELOC==1, na.rm=TRUE),
            Reshoring =  mean(RELOC==1, na.rm=TRUE),
            Both = mean(DELOC==1 & RELOC==1, na.rm=TRUE),
            nb_firms = n())
boundary_changes

regdata_what <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_what.dta"))

nb_firm_business_functions <- regdata_what %>%
  summarise(nb_deloc =  mean(DELOC, na.rm=TRUE), nb_reloc = mean(RELOC, na.rm=TRUE), nb_firm_business_functions = n()) 
nb_firm_business_functions

regdata_how <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_how.dta"))

nb_firm_business_functions_within_deloc <- regdata_how %>%
  filter(DELOC==1) %>%
  summarise(nb_deloc_intra = mean(DELOC_INTRA, na.rm=TRUE),
            nb_deloc_extra = mean(DELOC_EXTRA, na.rm=TRUE))
nb_firm_business_functions_within_deloc

nb_firm_business_functions_within_reloc <- regdata_how %>%
  filter(RELOC==1) %>%
  summarise(nb_deloc_intra = mean(RELOC_INTRA, na.rm=TRUE),
            nb_deloc_extra = mean(RELOC_EXTRA, na.rm=TRUE))
nb_firm_business_functions_within_reloc



## Sample, Weighted
regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))

boundary_changes <- regdata_who %>%
  filter(DELOC!=4 & RELOC!= 4 & keep == 1) %>%
  summarise(at_least_one =  weighted.mean(DELOC==1 | RELOC == 1, NUMPOIDS, na.rm=TRUE),
            Offshoring =  weighted.mean(DELOC==1, NUMPOIDS, na.rm=TRUE),
            Reshoring =  weighted.mean(RELOC==1, NUMPOIDS, na.rm=TRUE),
            Both = weighted.mean(DELOC==1 & RELOC==1, NUMPOIDS, na.rm=TRUE))
boundary_changes

regdata_what <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_what.dta"))

nb_firm_business_functions <- regdata_what %>%
  summarise(nb_deloc =  weighted.mean(DELOC, NUMPOIDS, na.rm=TRUE), nb_reloc = weighted.mean(RELOC, NUMPOIDS, na.rm=TRUE), nb_firm_business_functions = n()) 
nb_firm_business_functions

regdata_how <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_how.dta"))

nb_firm_business_functions_within_deloc <- regdata_how %>%
  filter(DELOC==1) %>%
  summarise(nb_deloc_intra = weighted.mean(DELOC_INTRA, NUMPOIDS, na.rm=TRUE),
            nb_deloc_extra = weighted.mean(DELOC_EXTRA, NUMPOIDS, na.rm=TRUE))
nb_firm_business_functions_within_deloc

nb_firm_business_functions_within_reloc <- regdata_how %>%
  filter(RELOC==1) %>%
  summarise(nb_deloc_intra = weighted.mean(RELOC_INTRA, NUMPOIDS, na.rm=TRUE),
            nb_deloc_extra = weighted.mean(RELOC_EXTRA, NUMPOIDS, na.rm=TRUE))
nb_firm_business_functions_within_reloc



## Survey
regdata_who_survey <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who_survey.dta"))
regdata_what_survey <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_what_survey.dta"))

## Survey, Unweighted
boundary_changes <- regdata_who_survey %>%
  filter(DELOC!=4 & RELOC!= 4) %>%
  summarise(at_least_one =  mean(DELOC==1 | RELOC == 1, na.rm=TRUE),
            Offshoring =  mean(DELOC==1, na.rm=TRUE),
            Reshoring =  mean(RELOC==1, na.rm=TRUE),
            Both = mean(DELOC==1 & RELOC==1, na.rm=TRUE),
            nb_firms = n())
boundary_changes

nb_firm_business_functions <- regdata_what_survey %>%
  summarise(nb_deloc =  mean(DELOC, na.rm=TRUE), nb_reloc = mean(RELOC, na.rm=TRUE), nb_firm_business_functions = n()) 
nb_firm_business_functions

nb_firm_business_functions_within_deloc <- regdata_what_survey %>%
  filter(DELOC==1) %>%
  summarise(nb_deloc_intra = mean(DELOC_INTRA, na.rm=TRUE),
            nb_deloc_extra = mean(DELOC_EXTRA, na.rm=TRUE))
nb_firm_business_functions_within_deloc

nb_firm_business_functions_within_reloc <- regdata_what_survey %>%
  filter(RELOC==1) %>%
  summarise(nb_deloc_intra = mean(RELOC_INTRA, na.rm=TRUE),
            nb_deloc_extra = mean(RELOC_EXTRA, na.rm=TRUE))
nb_firm_business_functions_within_reloc


## Survey, Weighted
boundary_changes <- regdata_who_survey %>%
  filter(DELOC!=4 & RELOC!= 4) %>%
  summarise(at_least_one =  weighted.mean(DELOC==1 | RELOC == 1, NUMPOIDS, na.rm=TRUE),
            Offshoring =  weighted.mean(DELOC==1, NUMPOIDS, na.rm=TRUE),
            Reshoring =  weighted.mean(RELOC==1, NUMPOIDS, na.rm=TRUE),
            Both = weighted.mean(DELOC==1 & RELOC==1, NUMPOIDS, na.rm=TRUE),
            nb_firms = n())
boundary_changes

nb_firm_business_functions <- regdata_what_survey %>%
  summarise(nb_deloc =  weighted.mean(DELOC, NUMPOIDS, na.rm=TRUE), nb_reloc = weighted.mean(RELOC, NUMPOIDS, na.rm=TRUE), nb_firm_business_functions = n()) 
nb_firm_business_functions

nb_firm_business_functions_within_deloc <- regdata_what_survey %>%
  filter(DELOC==1) %>%
  summarise(nb_deloc_intra = weighted.mean(DELOC_INTRA, NUMPOIDS, na.rm=TRUE),
            nb_deloc_extra = weighted.mean(DELOC_EXTRA, NUMPOIDS, na.rm=TRUE))
nb_firm_business_functions_within_deloc

nb_firm_business_functions_within_reloc <- regdata_what_survey %>%
  filter(RELOC==1) %>%
  summarise(nb_deloc_intra = weighted.mean(RELOC_INTRA, NUMPOIDS, na.rm=TRUE),
            nb_deloc_extra = weighted.mean(RELOC_EXTRA, NUMPOIDS, na.rm=TRUE))
nb_firm_business_functions_within_reloc


