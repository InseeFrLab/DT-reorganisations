////////////////////////////////////////////////////////////////////////////////
*  Where
////////////////////////////////////////////////////////////////////////////////
use "$data_path/2_final/regdata_where.dta", clear

local varlist_firm "log_VA_L log_K_L HS_nb_heures_frac foreign_MNE french_MNE CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7 ACHAT_BIEN ACHAT_SERVICE"

local varlist_where_1 "`varlist_firm' i.task_num log_avg_dist log_gdp_per_capita"
local varlist_where_2 "`varlist_firm' i.task_num i.destination_num task_HS_fracxlog_gdp_per_capita"
local varlist_where_3 "`varlist_firm' i.task_num i.destination_num task_HS_fracxlog_gdp_per_capita task_HS_fracxINDE"
local varlist_where_4 "`varlist_firm' i.task_num i.destination_num task_RD_fracxlog_gdp_per_capita"
local varlist_where_5 "`varlist_firm' i.task_num i.destination_num task_RD_fracxlog_gdp_per_capita task_RD_fracxINDE"

eststo clear

logit offshoring `varlist_where_1' [pweight=1/NUMPOIDS]
eststo: margins [pweight=1/NUMPOIDS], dydx(`varlist_where_1')  post	
su offshoring [aweight=NUMPOIDS]
estadd scalar avg = 100*r(mean)

logit offshoring `varlist_where_2' [pweight=1/NUMPOIDS]
eststo: margins [pweight=1/NUMPOIDS], dydx(`varlist_where_2')  post	
su offshoring [aweight=NUMPOIDS]
estadd scalar avg = 100*r(mean)
estadd local FE_3 "\checkmark"

logit offshoring `varlist_where_3' [pweight=1/NUMPOIDS]
eststo: margins [pweight=1/NUMPOIDS], dydx(`varlist_where_3')  post	
su offshoring [aweight=NUMPOIDS]
estadd scalar avg = 100*r(mean)
estadd local FE_3 "\checkmark"

logit offshoring `varlist_where_4' [pweight=1/NUMPOIDS]
eststo: margins [pweight=1/NUMPOIDS], dydx(`varlist_where_4')  post	
su offshoring [aweight=NUMPOIDS]
estadd scalar avg = 100*r(mean)
estadd local FE_3 "\checkmark"

logit offshoring `varlist_where_5' [pweight=1/NUMPOIDS]
eststo: margins [pweight=1/NUMPOIDS], dydx(`varlist_where_5')  post	
su offshoring [aweight=NUMPOIDS]
estadd scalar avg = 100*r(mean)
estadd local FE_3 "\checkmark"

estadd local FE_1 "\checkmark": *
estadd local FE_2 "\checkmark": *

** Paper Table
local note  "This table reports average marginal effects of the logit estimation of Equation \ref{eq:reg_where}. Covariates are relative to year 2017. We include one observation per firm $\times$ business function $\times$ destination. Observations are weighted by survey weights."
local title "Where are business functions offshored? Weighted regressions"
local label_table "reg_where_appendix" 

esttab using "$output_path/appendix_tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_avg_dist log_gdp_per_capita task_HS_fracxlog_gdp_per_capita task_HS_fracxINDE task_RD_fracxlog_gdp_per_capita task_RD_fracxINDE) ///
order(log_avg_dist log_gdp_per_capita task_HS_fracxlog_gdp_per_capita task_HS_fracxINDE task_RD_fracxlog_gdp_per_capita task_RD_fracxINDE) ///
title("`title'") ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{`title' \label{tab:`label_table'}}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is offshored in $ d $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \multicolumn{@span}{@{}p{\linewidth}@{}}{\footnotesize \emph{Notes:} `note' \sym{*} \(p<0.10\) \sym{**} \(p<0.05\) \sym{***} \(p<0.01\)} \end{tabular}\end{table}") ///
stats(avg FE_1 FE_2 FE_3 N, fmt(%5.3g 0 0 0 %9.0fc) label("Average (\%)" "Firm controls" "Business function fixed effects" "Destination fixed effects" "Observations")) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")
