import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\1617.csv", clear
generate kbb = k_percent - bb_percent if year == 2016
egen z_kbb = std(kbb) if year == 2016
egen z_poorlytopped = std(poorlytopped_percent) if year == 2016
egen z_poorlyunder = std(poorlyunder_percent) if year == 2016
egen z_barrel = std(barrel_batted_rate) if year == 2016
egen z_xwoba = std(xwoba) if year == 2016
replace z_xwoba = -1*z_xwoba if year == 2016
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2016
generate skwoba = (( .6883637 *z_poorlytopped) + ( .7577937 *z_poorlyunder) + (.64867  *z_kbb) + (-.3940266 *z_barrel)) if year == 2016
generate xwoba2016 = xwoba if year == 2016
generate xwoba2017 = xwoba if year == 2017
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
keep last_namefirst_name year xwoba skwoba
reshape wide xwoba skwoba, i(last_namefirst_name) j(year)
reg xwoba2017 skwoba2016
reg xwoba2017 xwoba2016