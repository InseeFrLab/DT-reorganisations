////////////////////////////////////////////////////////////////////////////////
*  Preparing data for regressions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
*  Who
////////////////////////////////////////////////////////////////////////////////
use "$data_path/1_intermediary/regdata_who.dta", clear

** Transform variables to suit Stata
destring IND, replace force
destring TYPE_ENT_grp, replace force
g foreign_MNE = TYPE_ENT_grp == 1
g french_MNE = TYPE_ENT_grp == 2
destring ACHAT_BIEN, replace force
destring ACHAT_SERVICE, replace force

g CORE_num = .
replace CORE_num = 1 if CORE == "IND"
replace CORE_num = 2 if CORE == "TRP"
replace CORE_num = 3 if CORE == "COM"
replace CORE_num = 4 if CORE == "ITC"
replace CORE_num = 5 if CORE == "SAF"
replace CORE_num = 6 if CORE == "ING"
replace CORE_num = 7 if CORE == "RD"
replace CORE_num = 8 if CORE == "AUTRE"

tab CORE_num, g(CORE_)

** Labels
do "$code_path/2_0_1_label_regdata.do"

save "$data_path/2_final/regdata_who.dta", replace

////////////////////////////////////////////////////////////////////////////////
*  What
////////////////////////////////////////////////////////////////////////////////
use "$data_path/1_intermediary/regdata_what.dta", clear

** Transform variables to suit Stata
destring IND, replace force
destring TYPE_ENT_grp, replace force
g foreign_MNE = TYPE_ENT_grp == 1
g french_MNE = TYPE_ENT_grp == 2
destring ACHAT_BIEN, replace force
destring ACHAT_SERVICE, replace force

g CORE_num = .
replace CORE_num = 1 if CORE == "IND"
replace CORE_num = 2 if CORE == "TRP"
replace CORE_num = 3 if CORE == "COM"
replace CORE_num = 4 if CORE == "ITC"
replace CORE_num = 5 if CORE == "SAF"
replace CORE_num = 6 if CORE == "ING"
replace CORE_num = 7 if CORE == "RD"
replace CORE_num = 8 if CORE == "AUTRE"

tab CORE_num, g(CORE_)


g task_num = .
replace task_num = 1 if task == "IND"
replace task_num = 2 if task == "TRP"
replace task_num = 3 if task == "COM"
replace task_num = 4 if task == "SI"
replace task_num = 5 if task == "ADMIN"
replace task_num = 6 if task == "ING"
replace task_num = 7 if task == "RD"
replace task_num = 8 if task == "AUTRE"
	

tab task_num, g(TASK_)

** Labels
do "$code_path/2_0_1_label_regdata.do"

save "$data_path/2_final/regdata_what.dta", replace


////////////////////////////////////////////////////////////////////////////////
*  How
////////////////////////////////////////////////////////////////////////////////
use "$data_path/1_intermediary/regdata_how.dta", clear

** Transform variables to suit Stata
destring IND, replace force
destring TYPE_ENT_grp, replace force
g foreign_MNE = TYPE_ENT_grp == 1
g french_MNE = TYPE_ENT_grp == 2
destring ACHAT_BIEN, replace force
destring ACHAT_SERVICE, replace force

g CORE_num = .
replace CORE_num = 1 if CORE == "IND"
replace CORE_num = 2 if CORE == "TRP"
replace CORE_num = 3 if CORE == "COM"
replace CORE_num = 4 if CORE == "ITC"
replace CORE_num = 5 if CORE == "SAF"
replace CORE_num = 6 if CORE == "ING"
replace CORE_num = 7 if CORE == "RD"
replace CORE_num = 8 if CORE == "AUTRE"

tab CORE_num, g(CORE_)

g task_num = .
replace task_num = 1 if task == "IND"
replace task_num = 2 if task == "TRP"
replace task_num = 3 if task == "COM"
replace task_num = 4 if task == "SI"
replace task_num = 5 if task == "ADMIN"
replace task_num = 6 if task == "ING"
replace task_num = 7 if task == "RD"
replace task_num = 8 if task == "AUTRE"
	
tab task_num, g(TASK_)
** Labels
do "$code_path/2_0_1_label_regdata.do"

save "$data_path/2_final/regdata_how.dta", replace

////////////////////////////////////////////////////////////////////////////////
*  Where
////////////////////////////////////////////////////////////////////////////////
use "$data_path/1_intermediary/regdata_where.dta", clear

** Transform variables to suit Stata
destring IND, replace force
destring TYPE_ENT_grp, replace force
g foreign_MNE = TYPE_ENT_grp == 1
g french_MNE = TYPE_ENT_grp == 2
destring ACHAT_BIEN, replace force
destring ACHAT_SERVICE, replace force

g CORE_num = .
replace CORE_num = 1 if CORE == "IND"
replace CORE_num = 2 if CORE == "TRP"
replace CORE_num = 3 if CORE == "COM"
replace CORE_num = 4 if CORE == "ITC"
replace CORE_num = 5 if CORE == "SAF"
replace CORE_num = 6 if CORE == "ING"
replace CORE_num = 7 if CORE == "RD"
replace CORE_num = 8 if CORE == "AUTRE"

tab CORE_num, g(CORE_)

encode task, generate(task_num)

g destination_num = .
replace destination_num = 1 if destination == "UE14"
replace destination_num = 2 if destination == "UE13"
replace destination_num = 3 if destination == "INDE"
replace destination_num = 4 if destination == "EUR"
replace destination_num = 5 if destination == "MAGHREB"
replace destination_num = 6 if destination == "UK"
replace destination_num = 7 if destination == "ASIE"
replace destination_num = 8 if destination == "USA"
replace destination_num = 9 if destination == "CHINE"
replace destination_num = 10 if destination == "aaRDM"

	  
tab destination_num, g(destination_)

** Remove firmXactivities with no displacement at all
bys entreprise_17 task_num: egen total_dest = sum(offshoring)
drop if total_dest == 0


** Labels
do "$code_path/2_0_1_label_regdata.do"

save "$data_path/2_final/regdata_where.dta", replace
