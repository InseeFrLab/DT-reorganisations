#===============================================================================
# Table 1: Number of reorganizing firms, reorganized business functions, integrated business functions
#===============================================================================

regdata_who <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))

boundary_changes <- regdata_who %>%
  filter(DELOC!=4 & RELOC!= 4 & keep == 1) %>%
  summarise(Offshoring =  sum(DELOC==1, na.rm=TRUE),
            Reshoring =  sum(RELOC==1, na.rm=TRUE),
            Both = sum(DELOC==1 & RELOC==1, na.rm=TRUE),
            nb_firms = n())

boundary_changes

regdata_what <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_what.dta"))

nb_firm_business_functions <- regdata_what %>%
  summarise(nb_deloc = sum(DELOC), nb_reloc = sum(RELOC), nb_firm_business_functions = n()) 
nb_firm_business_functions

regdata_how <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_how.dta"))

nb_firm_business_functions_within <- regdata_how %>%
  summarise(nb_deloc_intra = sum(DELOC_INTRA), nb_reloc_intra = sum(RELOC_INTRA),
            nb_deloc_extra = sum(DELOC_EXTRA), nb_reloc_extra = sum(RELOC_EXTRA),
            nb_deloc_both = sum(DELOC_INTRA*DELOC_EXTRA), nb_reloc_both = sum(RELOC_INTRA*RELOC_EXTRA)) 
nb_firm_business_functions_within
