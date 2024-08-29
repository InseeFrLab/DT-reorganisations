#===============================================================================
# Table 3: Statistics about business functions
#===============================================================================

stats_business_functions <- read_rds(paste0(data_path, "out/2_final/factor_content.rds"))

stats_business_functions <- stats_business_functions %>%
  filter(secteur!="CONS") %>%
  mutate(order = case_when(
    secteur == "COM" ~ "3",
    secteur == "IND"~ "1",
    secteur == "ING" ~ "6",
    secteur == "SI" ~ "4",
    secteur == "RD" ~ "7",
    secteur == "ADMIN" ~ "5",
    secteur == "TRP" ~ "2",
    .default = "Other"),
    label = case_when(
      secteur == "COM" ~ "Sales and Wholesale",
      secteur == "IND"~ "Manufacturing",
      secteur == "ING" ~ "Engineering",
      secteur == "SI" ~ "IT services",
      secteur == "RD" ~ "R\\&D",
      secteur == "ADMIN" ~ "Business services",
      secteur == "TRP" ~ "Transport and Logistics",
      .default = "Other")) %>%
  arrange(order) %>%
  select(c("label", "HS_frac", "RD_frac", "achats_wage_brut", "K_wage_brut", "K_inc_K"))%>%
  mutate(HS_frac=100*HS_frac,RD_frac=100*RD_frac)

xt <- xtable(stats_business_functions)
names(xt) <- c("Business function", "\\% HS", "\\% RD", "$\\frac{M}{W}$", "$\\frac{K}{W}$",  "$\\frac{K_{inc}}{K}$")

print(xtable(xt, 
             label = "tab:stats_business_functions",
             caption = "Sample description: Quantitative variables at the business function-level",
             align = c("l","l","c","c","c", "c", "c"),
             display = c("s", "s","fg","fg", "fg", "fg", "fg"), digits = 3),
              format.args = list(big.mark = ",", decimal.mark = "."),
              booktabs = TRUE, 
              hline.after = FALSE,
              file = paste0(output_path, "tables/stats_business_functions.tex"), 
              table.placement = "htbp", 
              caption.placement = "top",
              include.rownames = FALSE,
              sanitize.text.function = function(x){x},
              add.to.row = list(pos=list(-1,8), command=c("\\toprule \n", "\\bottomrule \n \\multicolumn{6}{@{}p{0.7\\linewidth}@{}}{\\scriptsize \\emph{Notes:} This table displays summary statistics of factor contents of business functions. \\% HS and \\% RD are the share of hours worked by high-skilled and R\\&D workers, respectively. $K_{corp}$ and $K_{inc}$ are the stock of physical and intangible capital, respectively. $M$ is the amount of materials purchases. $RD$ is the wage bill of R\\&D workers. $W$ is the total wage bill.} \\\\ \n")))

