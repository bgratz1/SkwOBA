import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\1819.csv", clear
generate kbb = k_percent - bb_percent if year == 2018
egen z_kbb = std(kbb) if year == 2018
egen z_poorlytopped = std(poorlytopped_percent) if year == 2018
egen z_poorlyunder = std(poorlyunder_percent) if year == 2018
egen z_barrel = std(barrel_batted_rate) if year == 2018
egen z_xwoba = std(xwoba) if year == 2018
replace z_xwoba = -1*z_xwoba if year == 2018
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2018
generate skwoba = (( .5239886   *z_poorlytopped) + (  .5906002   *z_poorlyunder) + (.740456 *z_kbb) + ( -.3859837  *z_barrel)) if year == 2018
generate xwoba2018 = xwoba if year == 2018
generate xwoba2019 = xwoba if year == 2019
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
keep last_namefirst_name year xwoba skwoba
reshape wide xwoba skwoba, i(last_namefirst_name) j(year)
reg xwoba2019 skwoba2018
reg xwoba2019 xwoba2018
reg xwoba2019 caps2018 xwoba2018
