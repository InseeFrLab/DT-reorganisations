////////////////////////////////////////////////////////////////////////////////
*  Table 7: How
////////////////////////////////////////////////////////////////////////////////
use "$data_path/2_final/regdata_how.dta", clear

local varlist_firm "log_VA_L log_K_L HS_nb_heures_frac foreign_MNE french_MNE CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7 ACHAT_BIEN ACHAT_SERVICE"

local varlist_how_1 "`varlist_firm' task_is_core"
local varlist_how_2 "`varlist_firm' task_is_core task_achats_wage_brut_log task_K_wage_brut_log"
local varlist_how_3 "`varlist_firm' task_is_core task_achats_wage_brut_log task_K_wage_brut_log task_HS_frac task_K_inc_K"

eststo clear

logit DELOC_INTRA_V_EXTRA `varlist_how_1' if nb_deloc >= 1
eststo: margins, dydx(`varlist_how_1')  post	
su DELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit RELOC_INTRA_V_EXTRA `varlist_how_1' if nb_reloc >= 1
eststo: margins, dydx(`varlist_how_1')  post	
su RELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit DELOC_INTRA_V_EXTRA `varlist_how_2' if nb_deloc >= 1
eststo: margins, dydx(`varlist_how_2')  post	
su DELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit RELOC_INTRA_V_EXTRA `varlist_how_2' if nb_reloc >= 1
eststo: margins, dydx(`varlist_how_2')  post	
su RELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit DELOC_INTRA_V_EXTRA `varlist_how_3' if nb_deloc >= 1
eststo: margins, dydx(`varlist_how_3')  post	
su DELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

logit RELOC_INTRA_V_EXTRA `varlist_how_3' if nb_reloc >= 1
eststo: margins, dydx(`varlist_how_3')  post	
su RELOC_INTRA_V_EXTRA
estadd scalar avg = 100*r(mean)

estadd local FE_1 "\checkmark": *

** Paper Table
local note  "This table reports average marginal effects of the logit estimation of Equation \ref{eq:reg_how}. Covariates are relative to year 2017. We include one observation per firm $\times $ business function. Columns (1)-(3)-(5) are restricted to firms with at least one offshored activity, and (2)-(4)-(6) to firms with at least one reshored activity."
local title "How are business functions reorganized: within or outside the firm?"
local label_table "reg_how_paper" 

esttab using "$output_path/tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_VA_L task_is_core task_is_core task_achats_wage_brut_log task_K_wage_brut_log task_HS_frac task_K_inc_K) ///
order(log_VA_L task_is_core task_is_core task_achats_wage_brut_log task_K_wage_brut_log task_HS_frac task_K_inc_K) ///
title("`title'") ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{`title' \label{tab:`label_table'}}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is reorganized within $ f $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \multicolumn{@span}{@{}p{\linewidth}@{}}{\footnotesize \emph{Notes:} `note' \sym{*} \(p<0.10\) \sym{**} \(p<0.05\) \sym{***} \(p<0.01\)} \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Firm controls" "Observations")) ///
mgroups("Offshoring" "Reshoring" "Offshoring" "Reshoring" "Offshoring" "Reshoring", pattern(1 1 1 1 1 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")

** Slides Table
local label_table "reg_how_slides" 

esttab using "$output_path/slides_tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_VA_L task_is_core task_is_core task_achats_wage_brut_log task_K_wage_brut_log task_HS_frac task_K_inc_K) ///
order(log_VA_L task_is_core task_is_core task_achats_wage_brut_log task_K_wage_brut_log task_HS_frac task_K_inc_K) ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ b $ is reorganized within $ f $} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Firm controls" "Observations")) ///
mgroups("Offshoring" "Reshoring" "Offshoring" "Reshoring" "Offshoring" "Reshoring", pattern(1 1 1 1 1 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")

************** Plot fixed effects
eststo clear
local varlist_how_4 "`varlist_firm' TASK_2 TASK_3 TASK_4 TASK_5 TASK_6 TASK_7 TASK_8"

logit DELOC_INTRA_V_EXTRA `varlist_how_4' if nb_deloc >= 1
eststo mdeloc: margins, dydx(`varlist_how_4')  post

logit RELOC_INTRA_V_EXTRA `varlist_how_4' if nb_reloc >= 1
eststo mreloc: margins, dydx(`varlist_how_4')  post

coefplot (mdeloc, label(Offhsoring)) (mreloc, label(Reshoring)), keep(TASK_2 TASK_3 TASK_4 TASK_5 TASK_6 TASK_7 TASK_8) xline(0) xlabel(, labsize(medium)) ylabel(, labsize(medium)) legend(ring(0) pos(2) col(1)) xtitle("Average marginal effect")

gr export "$output_path/figures/fixed_effects_how.pdf", as(pdf) replace 

