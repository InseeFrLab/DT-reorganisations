////////////////////////////////////////////////////////////////////////////////
*  Appendix Table: How, Replication of Costinot et al.
////////////////////////////////////////////////////////////////////////////////
use "$data_path/2_final/regdata_how.dta", clear

local varlist_firm "log_VA_L log_K_L HS_nb_heures_frac foreign_MNE french_MNE CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7 ACHAT_BIEN ACHAT_SERVICE"
local varlist_how_routine_1 "`varlist_firm' task_avg_r"
local varlist_how_routine_2 "`varlist_firm' task_avg_r task_K_L_log"
local varlist_how_routine_3 "`varlist_firm' task_avg_r task_K_L_log task_HS_frac task_RD_sales_log"

eststo clear

logit DELOC_INTRA_V_EXTRA `varlist_how_routine_1' if nb_deloc >= 1
eststo: margins, dydx(`varlist_how_routine_1')  post
su DELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit RELOC_INTRA_V_EXTRA `varlist_how_routine_1' if nb_reloc >= 1
eststo: margins, dydx(`varlist_how_routine_1')  post
su RELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit DELOC_INTRA_V_EXTRA `varlist_how_routine_2' if nb_deloc >= 1
eststo: margins, dydx(`varlist_how_routine_2')  post
su DELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit RELOC_INTRA_V_EXTRA `varlist_how_routine_2' if nb_reloc >= 1
eststo: margins, dydx(`varlist_how_routine_2')  post
su RELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit DELOC_INTRA_V_EXTRA `varlist_how_routine_3' if nb_deloc >= 1
eststo: margins, dydx(`varlist_how_routine_3')  post
su DELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit RELOC_INTRA_V_EXTRA `varlist_how_routine_3' if nb_reloc >= 1
eststo: margins, dydx(`varlist_how_routine_3')  post	
su RELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

estadd local FE_1 "\checkmark": *

** Paper Table
local note  "This table reports average marginal effects of the logit estimation of the same model as in \cite{costinot_2011}. We include one observation per firm $\times $ business function."
local title "How are business functions reorganized: within or outside the firm? \cite{costinot_2011}"
local label_table "reg_how_costinot" 

esttab using "$output_path/appendix_tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_VA_L task_avg_r task_K_L_log task_HS_frac task_RD_sales_log) ///
order(log_VA_L task_avg_r task_K_L_log task_HS_frac task_RD_sales_log) ///
title("`title'") ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{`title' \label{tab:`label_table'}}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is reorganized within $ f $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \multicolumn{@span}{@{}p{\linewidth}@{}}{\footnotesize \emph{Notes:} `note' \sym{*} \(p<0.10\) \sym{**} \(p<0.05\) \sym{***} \(p<0.01\)} \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Firm controls" "Observations")) ///
mgroups("Offshoring" "Reshoring" "Offshoring" "Reshoring" "Offshoring" "Reshoring", pattern(1 1 1 1 1 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")

** Slides Table
local label_table "reg_how_costinot_slides" 

esttab using "$output_path/slides_tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_VA_L task_avg_r task_K_L_log task_HS_frac task_RD_sales_log) ///
order(log_VA_L task_avg_r task_K_L_log task_HS_frac task_RD_sales_log) ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is reorganized within $ f $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Firm controls" "Observations")) ///
mgroups("Offshoring" "Reshoring" "Offshoring" "Reshoring" "Offshoring" "Reshoring", pattern(1 1 1 1 1 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")
