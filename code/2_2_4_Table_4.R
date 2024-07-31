#===============================================================================
# Table 3: Statistics about destinations
#===============================================================================

destination_data <- fread(paste0(data_path, "out/2_final/destination_data.csv")) %>%
  rename(destination = Zone2)

destination_data <- destination_data %>%
  mutate(order = case_when(
    destination == "USA" ~ "7",
    destination == "UK" ~ "6",
    destination == "UE13" ~ "2",
    destination == "UE14" ~ "1",
    destination == "MAGHREB" ~ "5",
    destination == "INDE" ~ "3",
    destination == "ASIE" ~ "8",
    destination == "EUR" ~ "4",
    destination == "CHINE" ~ "9",
    .default = "10"),
    label = case_when(
      destination == "USA" ~ "USA \\& Canada",
      destination == "UK" ~ "UK",
      destination == "UE13" ~ "EU 13",
      destination == "UE14" ~ "EU 14",
      destination == "MAGHREB" ~ "Maghreb",
      destination == "INDE" ~ "India",
      destination == "ASIE" ~ "Other Asia",
      destination == "EUR" ~ "Other Europe",
      destination == "CHINE" ~ "China",
      .default = "Rest of the World")) %>%
  select(label, nb_deloc, log_avg_dist, log_gdp_per_capita) %>%
  arrange(-nb_deloc) %>%
  bind_rows(summarise(.,
                      across(c("nb_deloc"), sum),
                      across(where(is.character), ~"Total")))

### Table ----------------------------------------------------------------------
xt <- xtable(destination_data)
names(xt) <- c("Destination", "Nb. of offshored functions", "(Log.) Distance", "(Log.) GDP per cap.")


print(xtable(xt, 
             label="tab:stats_destinations",
             caption="Sample description: Number of offshored functions and geography variables by destination",
             align=c("l", "l", "c", "c", "c"),
             display=c("s", "s", "fg", "fg", "fg"), digits=3),
      format.args=list(big.mark = ",", decimal.mark = "."),
      booktabs=TRUE, 
      hline.after=FALSE,
      file= paste0(output_path, "tables/stats_destinations.tex"), 
      table.placement="htbp", 
      caption.placement="top",
      include.rownames = FALSE,
      sanitize.text.function=function(x){x},
      add.to.row = list(pos=list(-1,11), 
                        command=c("\\toprule \n", 
                                  "\\bottomrule \n \\multicolumn{4}{@{}p{\\linewidth}@{}}{\\footnotesize \\emph{Notes:} This table displays the number of offshored business functions by offshoring destinations and the quantitative variables we use in the empirical exercises. Distance and GDP per capita are constructed as the weighted average of the corresponding country-level variables in 2017, weighted by country's nominal GDP. Distance, GDP and GDP per capita from CEPII-BACI. EU14 is Austria, Belgium, Denmark, Finland, Italy, Ireland, Germany, Greece, Luxembourg, Netherlands, Portugal, Spain, Sweden. EU13 is Bulgaria, Croatia, Cyprus, Czech Republic, Estonia, Hungary, Latvia, Lithuania, Malta, Poland, Romania, and Slovenia, and Slovakia.} \\\\ \n")))
