import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\2122.csv", clear
generate kbb = k_percent - bb_percent if year == 2021
egen z_kbb = std(kbb) if year == 2021
egen z_poorlytopped = std(poorlytopped_percent) if year == 2021
egen z_poorlyunder = std(poorlyunder_percent) if year == 2021
egen z_barrel = std(barrel_batted_rate) if year == 2021
egen z_xwoba = std(xwoba) if year == 2021
replace z_xwoba = -1*z_xwoba if year == 2021
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2021
generate skwoba = ((.5706632  *z_poorlytopped) + ( .6113039  *z_poorlyunder) + ( .6606267  *z_kbb) + (-.3784185 *z_barrel)) if year == 2021
generate xwoba2021 = xwoba if year == 2021
generate xwoba2022 = xwoba if year == 2022
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
keep last_namefirst_name year xwoba skwoba
reshape wide xwoba skwoba, i(last_namefirst_name) j(year)
reg xwoba2022 skwoba2021
reg xwoba2022 xwoba2021
reg xwoba2022 caps2021 xwoba2021
