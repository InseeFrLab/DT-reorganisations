////////////////////////////////////////////////////////////////////////////////
*  Table 6: What
////////////////////////////////////////////////////////////////////////////////
use "$data_path/2_final/regdata_what.dta", clear

local varlist_firm "log_VA_L log_K_L HS_nb_heures_frac foreign_MNE french_MNE CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7 ACHAT_BIEN ACHAT_SERVICE"

local varlist_task_1 "`varlist_firm' task_HS_frac"
local varlist_task_2 "`varlist_firm' task_avg_r_cog"
local varlist_task_3 "`varlist_firm' task_HS_frac task_avg_r_cog"
local varlist_task_4 "`varlist_firm' task_HS_frac task_avg_r_cog task_is_core"

local varlist_to_margins "HS_nb_heures_frac task_HS_frac task_avg_r_cog task_is_core"

eststo clear

logit DELOC `varlist_task_1', vce(cluster entreprise_17)
eststo: margins, dydx(`varlist_task_1')  post	
su DELOC
estadd scalar avg = 100*r(mean)

logit DELOC `varlist_task_2', vce(cluster entreprise_17)
eststo: margins, dydx(`varlist_task_2')  post
su DELOC
estadd scalar avg = 100*r(mean)

logit DELOC `varlist_task_3', vce(cluster entreprise_17)
eststo: margins, dydx(`varlist_task_3')  post
su DELOC
estadd scalar avg = 100*r(mean)

logit DELOC `varlist_task_4', vce(cluster entreprise_17)
eststo: margins, dydx(`varlist_task_4')  post
su DELOC
estadd scalar avg = 100*r(mean)

logit RELOC `varlist_task_1', vce(cluster entreprise_17)
eststo: margins, dydx(HS_nb_heures_frac task_HS_frac)  post
su RELOC
estadd scalar avg = 100*r(mean)

logit RELOC `varlist_task_2', vce(cluster entreprise_17)
eststo: margins, dydx(HS_nb_heures_frac task_avg_r_cog)  post
su RELOC
estadd scalar avg = 100*r(mean)

logit RELOC `varlist_task_3', vce(cluster entreprise_17)
eststo: margins, dydx(HS_nb_heures_frac task_HS_frac task_avg_r_cog)  post
su RELOC
estadd scalar avg = 100*r(mean)

logit RELOC `varlist_task_4', vce(cluster entreprise_17)
eststo: margins, dydx(HS_nb_heures_frac task_HS_frac task_avg_r_cog task_is_core)  post
su RELOC
estadd scalar avg = 100*r(mean)

estadd local FE_1 "\checkmark": *

** Paper Table
local note  "This table reports average marginal effects of the logit estimation of Equation \ref{eq:reg_what}. Covariates are relative to year 2017. We include one observation per firm $\times$ business function. Standard errors clustered at the firm-level. In Columns (5) to (8), because of the industry fixed-effects, we discard the industries in which no reshoring is observed: R\&D, engineering, and business services."
local title "What is reorganized?"
local label_table "reg_what_paper" 

esttab using "$output_path/tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(HS_nb_heures_frac task_HS_frac task_avg_r_cog task_is_core) ///
order(HS_nb_heures_frac task_HS_frac task_avg_r_cog task_is_core) ///
title("`title'") ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{`title' \label{tab:`label_table'}}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is reorganized by $ f $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \multicolumn{@span}{@{}p{\linewidth}@{}}{\footnotesize \emph{Notes:} `note' \sym{*} \(p<0.10\) \sym{**} \(p<0.05\) \sym{***} \(p<0.01\)} \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Firm controls" "Observations")) ///
mgroups("Offshoring" "Reshoring", pattern(1 0 0 0 1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")

** Paper Table
local label_table "reg_what_slides" 

esttab using "$output_path/slides_tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(HS_nb_heures_frac task_HS_frac task_avg_r_cog task_is_core) ///
order(HS_nb_heures_frac task_HS_frac task_avg_r_cog task_is_core) ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is reorganized by $ f $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Firm controls" "Observations")) ///
mgroups("Offshoring" "Reshoring", pattern(1 0 0 0 1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")


************** Plot fixed effects
local varlist_task_4 "`varlist_firm' TASK_2 TASK_3 TASK_4 TASK_5 TASK_6 TASK_7 TASK_8"

logit DELOC `varlist_task_4', vce(cluster entreprise_17)
eststo mdeloc: margins, dydx(`varlist_task_4')  post

logit RELOC `varlist_task_4', vce(cluster entreprise_17)
eststo mreloc: margins, dydx(`varlist_task_4')  post

coefplot (mdeloc, label(Offhsoring)) (mreloc, label(Reshoring)), keep(TASK_2 TASK_3 TASK_4 TASK_5 TASK_6 TASK_7 TASK_8) xlabel(, labsize(medium)) ylabel(, labsize(medium)) xline(0) legend(ring(0) pos(3) col(1)) xtitle("Average marginal effect")

gr export "$output_path/figures/fixed_effects_what.pdf", as(pdf) replace
