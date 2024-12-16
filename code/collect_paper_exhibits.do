//This do-file builds two folders containing the tables and figures in the paper, /figures_paper/ and /tables_paper/

local figures_folder = "$output_path/figures"
local tables_folder = "$output_path/tables"
local appendix_tables_folder = "$output_path/appendix_tables"

//Figures
copy "`figures_folder'/fixed_effects_who.pdf" "`figures_folder'/Figure_1.pdf", replace
copy "`figures_folder'/fixed_effects_how.pdf" "`figures_folder'/Figure_2.pdf", replace
copy "`figures_folder'/fixed_effects_where.pdf" "`figures_folder'/Figure_3.pdf", replace

//Tables

copy "`tables_folder'/stats_firms.tex" "`tables_folder'/Table_3.tex", replace
copy "`tables_folder'/stats_business_functions.tex" "`tables_folder'/Table_4.tex", replace
copy "`tables_folder'/stats_destinations.tex" "`tables_folder'/Table_5.tex", replace
copy "`tables_folder'/reg_who_paper.tex" "`tables_folder'/Table_6.tex", replace
copy "`tables_folder'/reg_what_paper.tex" "`tables_folder'/Table_7.tex", replace
copy "`tables_folder'/reg_how_paper.tex" "`tables_folder'/Table_8.tex", replace
copy "`tables_folder'/reg_where_paper.tex" "`tables_folder'/Table_9.tex", replace

copy "`appendix_tables_folder'/nb_changes_comparison.tex" "`appendix_tables_folder'/Table_S1.tex", replace
copy "`appendix_tables_folder'/reg_who_appendix.tex" "`appendix_tables_folder'/Table_S2.tex", replace
copy "`appendix_tables_folder'/reg_what_appendix.tex" "`appendix_tables_folder'/Table_S3.tex", replace
copy "`appendix_tables_folder'/reg_how_appendix.tex" "`appendix_tables_folder'/Table_S4.tex", replace
copy "`appendix_tables_folder'/reg_where_appendix.tex" "`appendix_tables_folder'/Table_S5.tex", replace
copy "`appendix_tables_folder'/reg_how_costinot.tex" "`appendix_tables_folder'/Table_S6.tex", replace





