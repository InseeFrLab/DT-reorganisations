#===============================================================================
# Table 2: Statistics about firms
#===============================================================================

stats_firms <- haven::read_dta(paste0(data_path, "out/1_intermediary/regdata_who.dta"))

stats_firms <- stats_firms %>%
  filter(keep==1) %>%
  mutate(
    VA = vacf,
    VA = VA/1000,
    K = K/1000,
    HS =100*HS_nb_heures_frac,
    RD =100* RD_nb_heures_frac
  ) 

size_recap <- rbind(stats_firms %>%
                      summarise(
                        avg = mean(eqtp, na.rm=TRUE),
                        p50 = median(eqtp, na.rm=TRUE),
                        sd = sd(eqtp, na.rm=TRUE)
                      ) %>% mutate(Variable = "L"),
                    stats_firms %>%
                      summarise(
                        avg = mean(VA, na.rm=TRUE),
                        p50 = median(VA, na.rm=TRUE),
                        sd = sd(VA, na.rm=TRUE)
                      )  %>% mutate(Variable = "VA"),
                    stats_firms %>%
                      summarise(
                        avg = mean(K, na.rm=TRUE),
                        p50 = median(K, na.rm=TRUE),
                        sd = sd(K, na.rm=TRUE)
                      )  %>% mutate(Variable = "K"),
                    stats_firms %>%
                      summarise(
                        avg = mean(1000*K/eqtp, na.rm=TRUE),
                        p50 = median(1000*K/eqtp, na.rm=TRUE),
                        sd = sd(1000*K/eqtp, na.rm=TRUE)
                      )  %>% mutate(Variable = "$\\frac{K}{L}$"),
                    stats_firms %>%
                      summarise(
                        avg = mean(1000*VA/eqtp, na.rm=TRUE),
                        p50 = median(1000*VA/eqtp, na.rm=TRUE),
                        sd = sd(1000*VA/eqtp, na.rm=TRUE)
                      )  %>% mutate(Variable = "$\\frac{VA}{L}$"),
                    stats_firms %>%
                      summarise(
                        avg = mean(HS, na.rm=TRUE),
                        p50 = median(HS, na.rm=TRUE),
                        sd = sd(HS, na.rm=TRUE)
                      )  %>% mutate(Variable = "\\% HS"),
                    stats_firms %>%
                      summarise(
                        avg = mean(RD, na.rm=TRUE),
                        p50 = median(RD, na.rm=TRUE),
                        sd = sd(RD, na.rm=TRUE)
                      )  %>% mutate(Variable = "\\% RD")
) %>% 
  select(c("Variable", "avg", "p50", "sd"))

# Output 

xt <- xtable(size_recap)
names(xt) <- c("Variable", "Avg.", "Med.", "Std. Dev.")

print(xtable(xt, 
             label="tab:stats_fare",
             caption="Sample description: Quantitative variables at the firm-level",
             align=c("l","l","c","c", "c"),
             display=c("s","s","fg","fg", "fg"), digits=4),
      format.args=list(big.mark = ",", decimal.mark = "."),
      booktabs=TRUE, 
      hline.after=FALSE,
      file=paste0(output_path, "tables/stats_firms.tex"), 
      table.placement="htbp", 
      caption.placement="top",
      include.rownames = FALSE,
      sanitize.text.function=function(x){x},
      add.to.row = list(pos=list(-1,7), command=c("\\toprule \n", "\\bottomrule \n \\multicolumn{4}{@{}p{0.45\\linewidth}@{}}{\\scriptsize \\emph{Notes:} This table displays summary statistics of quantitative variables in our sample. L is the number of workers. Value added (VA) and capital stock (K) are expressed in millions of euros. Value added and capital stock per worker are expressed in thousands of euros per worker.} \\\\ \n")))
