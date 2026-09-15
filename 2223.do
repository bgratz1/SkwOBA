import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\2223.csv", clear
generate kbb = k_percent - bb_percent if year == 2022
egen z_kbb = std(kbb) if year == 2022
egen z_poorlytopped = std(poorlytopped_percent) if year == 2022
egen z_poorlyunder = std(poorlyunder_percent) if year == 2022
egen z_barrel = std(barrel_batted_rate) if year == 2022
egen z_xwoba = std(xwoba) if year == 2022
replace z_xwoba = -1*z_xwoba if year == 2022
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2022
generate skwoba = ((.6437686 *z_poorlytopped) + (.6813552 *z_poorlyunder) + ( .6852756 *z_kbb) + (-.2971638*z_barrel)) if year == 2022
generate xwoba2022 = xwoba if year == 2022
generate xwoba2023 = xwoba if year == 2023
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
keep last_namefirst_name year xwoba skwoba
reshape wide xwoba skwoba, i(last_namefirst_name) j(year)
reg xwoba2023 skwoba2022
reg xwoba2023 xwoba2022
reg xwoba2023 caps2022 xwoba2022