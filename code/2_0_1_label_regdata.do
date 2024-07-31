* Firm
cap lab var log_VA_L "(Log) Value added per worker$ _f$"
cap lab var log_K_L "(Log) Capital per worker$ _f$"
cap lab var HS_nb_heures_frac "Share of HS workers$ _f$"
cap lab var IND "Manufacturing firm$ _f$"
cap lab var foreign_MNE "FMNE$ _f$"
cap lab var french_MNE "DMNE$ _f$"
cap lab var ACHAT_BIEN "Foreign goods purch.$ _f$"
cap lab var ACHAT_SERVICE "Foreign services purch.$ _f$"

cap lab var CORE_1 "Manufacturing"
cap lab var CORE_2 "Transport and Logistics"
cap lab var CORE_3 "Sales and Wholesale"
cap lab var CORE_4 "IT services"
cap lab var CORE_5 "Business services"
cap lab var CORE_6 "Engineering"
cap lab var CORE_7 "R&D"
cap lab var CORE_8 "Other"

cap lab drop task_names
lab define task_names 1 "Manufacturing" 2 "Transport and Logistics" 3 "Sales and Wholesale" 4 "IT services" 5 "Business services" 6 "Engineering" 7 "R&D" 8 "Other"
lab values CORE_num task_names

* Business function
cap lab var task_is_core "Core business function$ _{fb}$"

cap lab var task_HS_frac "Share of HS workers$ _b$"
cap lab var task_HS_frac_log "Log Share of HS workers$ _b$"
cap lab var task_RD_frac "Share of RD workers$ _b$"
cap lab var task_RD_frac_log "Log Share of RD workers$ _b$"
cap lab var task_HS_wage_brut_log "Log $\frac{HS}{W}_b$"
cap lab var task_RD_wage_brut_log "Log $\frac{RD}{W}_b$"
cap lab var task_achats_wage_brut_log "Log $\frac{M}{W}_b$"
cap lab var task_K_wage_brut_log "Log $\frac{K}{W}_b$"
cap lab var task_K_L_log "Log $\frac{K}{L}_b$"
cap lab var task_K_inc_K "$(\frac{K_{inc}}{K})_b$"
cap lab var task_I_wage_brut_log "Log $(\frac{I}{W})_b$"
cap lab var task_RD_sales_log "Log $(\frac{RD}{Sales})_b$"

cap lab var task_avg_r_cog "Routineness$ _b$"
cap lab var task_avg_r "Routineness$ _b$"

cap lab var TASK_1 "Manufacturing"
cap lab var TASK_2 "Transport and Logistics"
cap lab var TASK_3 "Sales and Wholesale"
cap lab var TASK_4 "IT services"
cap lab var TASK_5 "Business services"
cap lab var TASK_6 "Engineering"
cap lab var TASK_7 "R&D"
cap lab var TASK_8 "Other"

cap lab values task_num task_names
* Destination
cap lab var log_avg_dist "Log Average distance$ _d$"
cap lab var log_gdp_per_capita "Log GDP/Capita$ _d$"
cap lab var task_HS_fracxlog_gdp_per_capita "Share of HS workers$ _b$ $\times$ Log GDP/Capita$ _d$"
cap lab var task_RD_fracxlog_gdp_per_capita "Share of RD workers$ _b$ $\times$ Log GDP/Capita$ _d$"
cap lab var task_HS_fracxINDE "Share of HS workers$ _b$ $\times$ India$ _d$"
cap lab var task_RD_fracxINDE "Share of RD workers$ _b$ $\times$ India$ _d$"

cap lab var destination_1 "EU 14"
cap lab var destination_2 "EU 13"
cap lab var destination_3 "India"
cap lab var destination_4 "Other Europe"
cap lab var destination_5 "Maghreb"
cap lab var destination_6 "United Kingdom"
cap lab var destination_7 "Other Asia"
cap lab var destination_8 "USA & Canada"
cap lab var destination_9 "China"
cap lab var destination_10 "Rest of the World"


cap lab drop destination_names
lab define destination_names 1 "EU 14" 2 "EU 13" 3 "India" 4 "Other Europe" 5 "Maghreb" 6 "United Kingdom" 7 "Other Asia" 8 "USA & Canada" 9 "China" 10 "Rest of the World"
cap lab values destination_num destination_names
