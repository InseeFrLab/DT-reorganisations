////////////////////////////////////////////////////////////////////////////////
*  Reorganizing the supply-chain: Who, What, How and Where
* Master do-file
////////////////////////////////////////////////////////////////////////////////
set scheme plotplainblind
set more off

* Convert regressions datasets to Stata-friendly datasets
do "$code_path/2_0_0_prepare_regdata.do"

* Results of the paper
do "$code_path/2_2_5_Table_5.do"
do "$code_path/2_2_6_Table_6.do"
do "$code_path/2_2_7_Table_7.do"
do "$code_path/2_2_8_Table_8.do"
do "$code_path/2_4_2_Appendix_Table_2.do"
do "$code_path/2_4_3_Appendix_Table_3.do"
do "$code_path/2_4_4_Appendix_Table_4.do"
do "$code_path/2_4_5_Appendix_Table_5.do"
do "$code_path/2_4_6_Appendix_Table_6.do"
