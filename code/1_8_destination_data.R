#===============================================================================
# This code creates the destination-level dataset used in Where regressions
#===============================================================================

# Import Gravity database ------------------------------------------------------
gravity_countries <- read_dta(paste0(gravity_path, "Countries_V202211.dta"),  encoding = "UTF-8")
gravity <- read_dta(paste0(gravity_path, "Gravity_V202211.dta"),  encoding = "UTF-8")

# Country groups ---------------------------------------------------------------

ue14 <- c("Belgium", "Denmark", "Germany", "Greece", "Spain", "Ireland", "Italy", "Luxembourg", "Netherlands", "Austria", "Portugal", "Finland", "Sweden" )
ue13 <- c("Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Romania", "Slovakia", "Slovenia")
europe_autre <- c("Albania", "Belarus", "Bosnia and Herzegovina" , "Georgia", "Liechtenstein", "North Macedonia", "Moldova", "Montenegro", "Norway", "Russia", "Serbia", "Switzerland", "Ukraine")
asia <- c("Afghanistan","Australia", "Azerbaijan", "Bahrain", "Bangladesh", "Bhutan", "Brunei", "Cambodia", "Hong Kong", "Indonesia", "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", "Macao", "Malaysia", "Maldives", "Mongolia", "Myanmar", "Nepal", "Northern Mariana Islands","North Korea", "Oman", "Pakistan", "Palestine", "Philippines", "Qatar", "Saudi Arabia", "Singapore", "South Korea", "Sri Lanka", "Syria", "Taiwan", "Tajikistan", "Thailand", "Timor-Leste", "Turkey", "Turkmenistan", "United Arab Emirates", "Uzbekistan", "Vietnam",  "New Zealand", "Yemen", "American Samoa", "Christmas Island", "Cocos (Keeling) Islands", "Cook Islands", "Fiji", "Guam", "Kiribati", "Marshall Islands", "Micronesia", "Nauru", "New Caledonia", "Niue", "Norfolk Island", "Palau", "Papua New Guinea", "Pitcairn Islands", "Samoa", "Solomon Islands", "Tokelau", "Tonga", "Tuvalu", "Vanuatu", "Wallis and Futuna")

maghreb <- c("Algeria",  "Morocco", "Tunisia")
northam <-c("United States of America", "Canada","Puerto Rico")
southam <- c("Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Costa Rica", "Cuba", "Dominican Republic" ,"Dominica", "Ecuador", "El Salvador", "Guatemala",  "Grenada","Guyana", "Haiti", "Honduras", "Jamaica", "Mexico", "Nicaragua", "Panama", "Paraguay", "Peru", "Puerto Rico","Suriname" ,"Trinidad and Tobago", "Uruguay", "Venezuela", "Bahamas", "Barbados", "Belize", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Antigua and Barbuda",    "Aruba", "Bonaire, Sint Eustatius and Saba" , "Curacao")
africa <- c("Angola", "Benin", "Botswana", "Burkina Faso", "Burundi", "Cameroon", "Cape Verde", "Central African Republic", "Chad", "Comoros", "Congo, Democratic Rep. of the", "Congo, Rep. of the","Cote d'Ivoire", "Djibouti", "Equatorial Guinea", "Egypt","Eritrea", "Eswatini", "Ethiopia", "Gabon", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", "Mali", "Mauritania", "Mozambique", "Namibia", "Niger", "Nigeria", "Rwanda", "Saint Helena", "Sao Tome and Principe", "Senegal", "Seychelles", "Sierra Leone", "Somalia", "South Africa", "South Sudan", "Sudan", "Tanzania", "Togo", "Uganda", "Western Sahara","Zambia", "Zimbabwe")
uk <- c("United Kingdom")        
france <- c("France")
chine<-c("China")
inde<-c("India")

# Clean the data ---------------------------------------------------------------
geodata <- gravity %>% filter(iso3_d == "FRA", iso3_o != "FRA") %>%
  select("country_id_o", "year", "country_id_d", "country_exists_o", "dist", "pop_o", "gdp_o", "gdpcap_o")

geodata <- merge(geodata, gravity_countries %>% select("country_id","country"), by.x = "country_id_o", by.y = "country_id", all.x= TRUE) %>% 
  filter(country_exists_o==1)

geodata <- geodata %>% mutate(country_id_o = str_sub(country_id_o, 1, 3))

geodata <- geodata %>% filter(!(is.na(gdp_o)))

geodata<- geodata %>% 
  filter(country %in% c(ue13, ue14, europe_autre, asia, maghreb, northam, southam, africa, uk, france, chine, inde))

geodata$Zone <- ifelse(geodata$country %in% ue13, "UE13",
                       ifelse(geodata$country %in% ue14, "UE14",
                              ifelse(geodata$country %in% europe_autre, "EUR",
                                     ifelse(geodata$country %in% asia, "ASIE",
                                            ifelse(geodata$country %in% maghreb, "MAGHREB",
                                                   ifelse(geodata$country %in% northam, "USA",
                                                          ifelse(geodata$country %in% southam, "AMERIQ",
                                                                 ifelse(geodata$country %in% africa, "AFRIQUE",
                                                                        ifelse(geodata$country %in% uk, "UK",
                                                                               ifelse(geodata$country %in% france, "FRANCE",
                                                                                      ifelse(geodata$country %in% chine, "CHINE",
                                                                                             ifelse(geodata$country %in% inde, "INDE",
                                                                                                    "Autre"))))))))))))


# Weighted means of variables --------------------------------------------------

geodata <- geodata %>% group_by(Zone) %>% 
  summarise(avg_gdp = weighted.mean(gdp_o, gdp_o, na.rm = TRUE),
            avg_pop = weighted.mean(pop_o, gdp_o, na.rm = TRUE),
            avg_dist = weighted.mean(dist, gdp_o, na.rm = TRUE),
            gdp_total_zone = sum(gdp_o, na.rm = TRUE)) %>%
  mutate(gdp_per_capita = avg_gdp/avg_pop)

# Weighted means at the aggregated zone level ----------------------------------
geodata$Zone2 <- ifelse(!(geodata$Zone %in% list("AMERIQ", "AFRIQUE", "Rest of the world")), geodata$Zone, "aaRDM")

# We weight by number of offshorings
cam <- read_rds(paste0(data_path, "out/2_final/cam_augmented.rds"))
weights <- cam %>%
  select(starts_with("DELOC_")) %>%
  rowwise() %>%
  mutate(weight_CHINE = sum(c_across(ends_with("CHINE")) == 1, na.rm = TRUE),
         weight_INDE = sum(c_across(ends_with("INDE")) == 1, na.rm = TRUE),
         weight_UE13 = sum(c_across(ends_with("UE13")) == 1, na.rm = TRUE),
         weight_UE14 = sum(c_across(ends_with("UE14")) == 1, na.rm = TRUE),
         weight_EUR = sum(c_across(ends_with("EUR")) == 1, na.rm = TRUE),
         weight_ASIE = sum(c_across(ends_with("ASIE")) == 1, na.rm = TRUE),
         weight_MAGHREB = sum(c_across(ends_with("MAGHREB")) == 1, na.rm = TRUE),
         weight_AFRIQUE = sum(c_across(ends_with("AFRIQUE")) == 1, na.rm = TRUE),
         weight_USA = sum(c_across(ends_with("USA")) == 1, na.rm = TRUE),
         weight_AMERIQ = sum(c_across(ends_with("AMERIQ")) == 1, na.rm = TRUE),
         weight_UK = sum(c_across(ends_with("UK")) == 1, na.rm = TRUE)
  ) %>% 
  ungroup() %>%
  select(starts_with("weight_")) %>% 
  summarise(across(everything(), sum)) %>% 
  pivot_longer(cols = starts_with("weight_"), 
               names_to = "column", 
               values_to = "weight") %>%
  mutate(Zone = gsub("weight_", "", column))

geodata <- merge(geodata, weights, by.x = "Zone", by.y = "Zone", all = TRUE)

geodata <- geodata %>% group_by(Zone2) %>% 
  summarise(avg_gdp = weighted.mean(avg_gdp, weight, na.rm = TRUE),
            avg_pop = weighted.mean(avg_pop, weight, na.rm = TRUE),
            avg_dist = weighted.mean(avg_dist, weight, na.rm = TRUE),
            gdp_total_zone = sum(gdp_total_zone, na.rm = TRUE),
            nb_deloc = sum(weight)) %>%
  mutate(gdp_per_capita = avg_gdp/avg_pop)

# Take the log -----------------------------------------------------------------
geodata <- geodata %>%
  mutate(
    log_avg_gdp = log(avg_gdp),
    log_avg_dist = log(avg_dist),
    log_gdp_per_capita = log(gdp_per_capita)
  ) 

# Save -------------------------------------------------------------------------
fwrite(geodata, file = paste0(data_path, "out/2_final/destination_data.csv "), row.names = FALSE)
