import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\1516.csv", clear
generate kbb = k_percent - bb_percent if year == 2015
egen z_kbb = std(kbb) if year == 2015
egen z_poorlytopped = std(poorlytopped_percent) if year == 2015
egen z_poorlyunder = std(poorlyunder_percent) if year == 2015
egen z_barrel = std(barrel_batted_rate) if year == 2015
egen z_xwoba = std(xwoba) if year == 2015
replace z_xwoba = -1*z_xwoba if year == 2015
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2015
generate skwoba = (( .6229003 *z_poorlytopped) + (  .676829 *z_poorlyunder) + (.6685517 *z_kbb) + (-.3207057 *z_barrel)) if year == 2015
generate xwoba2015 = xwoba if year == 2015
generate xwoba2016 = xwoba if year == 2016
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
keep last_namefirst_name year xwoba skwoba
reshape wide xwoba skwoba, i(last_namefirst_name) j(year)
reg xwoba2016 skwoba2015
reg xwoba2016 xwoba2015


