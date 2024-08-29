////////////////////////////////////////////////////////////////////////////////
*  Table 5: Who
////////////////////////////////////////////////////////////////////////////////
use "$data_path/2_final/regdata_who.dta", clear

local varlist0 "log_VA_L log_K_L HS_nb_heures_frac foreign_MNE french_MNE"
local varlist1 "`varlist0' IND"
local varlist2 "`varlist0' CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7"
local varlist3 "`varlist0' CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7 ACHAT_BIEN ACHAT_SERVICE"

eststo clear
logit DELOC `varlist1'
eststo m1m: margins, dydx(`varlist1')  post
su DELOC
estadd scalar avg = 100*r(mean)
logit RELOC `varlist1'
eststo m2m: margins, dydx(`varlist1')  post
su RELOC
estadd scalar avg = 100*r(mean)
logit DELOC_ou_RELOC `varlist1'
eststo m3m: margins, dydx(`varlist1')  post
su DELOC_ou_RELOC
estadd scalar avg = 100*r(mean)
logit DELOC_ou_RELOC `varlist2'
eststo m4m: margins, dydx(`varlist2')  post
su DELOC_ou_RELOC
estadd scalar avg = 100*r(mean)
estadd local FE_1 "\checkmark"
logit DELOC_ou_RELOC `varlist3'
eststo m5m: margins, dydx(`varlist3')  post
su DELOC_ou_RELOC
estadd scalar avg = 100*r(mean)
estadd local FE_1 "\checkmark"

** Paper Table
local note  "This table reports average marginal effects of the logit estimation of Equation \ref{eq:reg_who}. Covariates are relative to year 2017. We include one observation per firm."
local title "Who reorganizes its value chain?"
local label_table "reg_who_paper" 

esttab using "$output_path/tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_VA_L log_K_L HS_nb_heures_frac IND foreign_MNE french_MNE ACHAT_BIEN ACHAT_SERVICE ) ///
order(log_VA_L log_K_L HS_nb_heures_frac IND foreign_MNE french_MNE ACHAT_BIEN ACHAT_SERVICE) ///
title("`title'") ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \footnotesize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{`title' \label{tab:`label_table'}}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ f $ reorganizes} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \multicolumn{@span}{@{}p{0.85\linewidth}@{}}{\footnotesize \emph{Notes:} `note' \sym{*} \(p<0.10\) \sym{**} \(p<0.05\) \sym{***} \(p<0.01\)} \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Industry fixed effects" "Observations")) ///
mgroups("Offshoring" "Reshoring" "Reorganization", pattern(1 1 1 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")

** Slides Table
local label_table "reg_who_slides" 

esttab using "$output_path/slides_tables/`label_table'.tex", replace ///
b(3) se(3) ///
keep(log_VA_L log_K_L HS_nb_heures_frac IND foreign_MNE french_MNE ACHAT_BIEN ACHAT_SERVICE ) ///
order(log_VA_L log_K_L HS_nb_heures_frac IND foreign_MNE french_MNE ACHAT_BIEN ACHAT_SERVICE) ///
label booktabs compress nonotes nomtitle ///
prehead(`"\begin{table}[htbp] \scriptsize \centering"' `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\renewcommand{\arraystretch}{1}"' `"\begin{tabular}{l*{@M}{c}}"' `"\toprule"' `"&\multicolumn{@M}{c}{Dep. Var = 1 if $ f $ reorganizes} \\"' `"\cmidrule(lr){2-@span}"' ) ///
postfoot("\bottomrule \end{tabular}\end{table}") ///
stats(avg FE_1 N, fmt(%5.3g 0 %9.0fc) label("Average (\%)" "Industry fixed effects" "Observations")) ///
mgroups("Offshoring" "Reshoring" "Reorganization", pattern(1 1 1 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* 0.10 ** 0.05 *** 0.01) substitute("\_ _")

************** Plot fixed effects
logit DELOC `varlist3'
eststo mdeloc: margins, dydx(`varlist3')  post
logit RELOC `varlist3'
eststo mreloc: margins, dydx(`varlist3')  post

coefplot (mdeloc, label(Offhsoring)) (mreloc, label(Reshoring)), keep(CORE_1 CORE_2 CORE_3 CORE_4 CORE_5 CORE_6 CORE_7) xlabel(, labsize(medium)) ylabel(, labsize(medium)) xline(0) legend(ring(0) pos(3) col(1)) xtitle("Average marginal effect")
gr export "$output_path/figures/fixed_effects_who.pdf", as(pdf) replace

