import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\2324.csv", clear
generate kbb = k_percent - bb_percent if year == 2023
egen z_kbb = std(kbb) if year == 2023
egen z_poorlytopped = std(poorlytopped_percent) if year == 2023
egen z_poorlyunder = std(poorlyunder_percent) if year == 2023
egen z_barrel = std(barrel_batted_rate) if year == 2023
egen z_xwoba = std(xwoba) if year == 2023
replace z_xwoba = -1*z_xwoba if year == 2023
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2023
generate caps = ((.5870997 *z_poorlytopped) + (.6687938*z_poorlyunder) + (.7730293 *z_kbb) + (-.3480772*z_barrel)) if year == 2023
generate xwoba2023 = xwoba if year == 2023
generate xwoba2024 = xwoba if year == 2024
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
keep last_namefirst_name year xwoba caps
reshape wide xwoba caps, i(last_namefirst_name) j(year)
reg xwoba2024 caps2023
reg xwoba2024 xwoba2023
reg xwoba2024 caps2023 xwoba2023
