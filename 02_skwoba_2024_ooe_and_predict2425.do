import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\comparison.csv", clear
generate kbb = k_percent - bb_percent if year == 2024
egen z_kbb = std(kbb) if year == 2024
egen z_poorlytopped = std(poorlytopped_percent) if year == 2024
egen z_poorlyunder = std(poorlyunder_percent) if year == 2024
egen z_barrel = std(barrel_batted_rate) if year == 2024
egen z_xwoba = std(xwoba) if year == 2024
replace z_xwoba = -1*z_xwoba if year == 2024
reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year == 2024
generate skwoba = ((.6550074*z_poorlytopped) + (.7776122*z_poorlyunder) + (.7400951*z_kbb) + (-.2803665*z_barrel)) if year == 2024
egen z_skwoba = std(skwoba) if year == 2024
generate ooa = z_xwoba - z_skwoba if year == 2024
egen z_ooa = std(ooa) if year == 2024
sort z_skwoba
sort z_ooa
generate skwoba2024 = skwoba if year == 2024
generate skwoba2025 = skwoba if year == 2025
bysort player_id: egen n_years = count(year)
drop if n_years < 2
drop n_years
generate xwoba_diff = -1*(xwoba2025 - xwoba2024)
egen z_xwoba_diff = std(xwoba_diff)
keep last_namefirst_name year xwoba skwoba ooa
reshape wide xwoba skwoba ooa, i(last_namefirst_name) j(year)
generate xwoba_diff = -1*(xwoba2025 - xwoba2024)
egen z_xwoba_diff = std(xwoba_diff)
egen z_skwoba2024 = std(skwoba2024)
corr z_skwoba2024 z_xwoba_diff
reg z_xwoba_diff z_skwoba2024

reg z_xwoba_diff z_skwoba2024 xwoba2024
reg xwoba2025 z_skwoba2024 xwoba2024

reg xwoba2025 ooa2024
reg xwoba_diff ooa2024
reg xwoba2025 skwoba2024
reg xwoba2025 xwoba2024
reg xwoba2025 skwoba2024 xwoba2024


import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\comparison.csv", clear

keep if year==2024 | year==2025

bysort player_id year: keep if _n==1

bysort player_id: egen has2024 = max(year==2024)
bysort player_id: egen has2025 = max(year==2025)
keep if has2024 & has2025
drop has2024 has2025

generate kbb = k_percent - bb_percent

egen z_kbb = std(kbb) if year==2024
egen z_poorlytopped = std(poorlytopped_percent) if year==2024
egen z_poorlyunder = std(poorlyunder_percent) if year==2024
egen z_barrel = std(barrel_batted_rate) if year==2024
egen z_xwoba = std(xwoba) if year==2024
replace z_xwoba = -1*z_xwoba if year==2024

reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel if year==2024

generate skwoba = ((.6550074*z_poorlytopped) + (.7776122*z_poorlyunder) + (.7400951*z_kbb) + (-.2803665*z_barrel)) if year==2024

egen z_skwoba = std(skwoba) if year==2024

generate ooe = z_xwoba - z_skwoba if year==2024
egen z_ooe = std(ooe) if year==2024

keep player_id last_namefirst_name year xwoba skwoba ooe

reshape wide xwoba skwoba ooe, i(player_id last_namefirst_name) j(year)


generate xwoba_diff = -1*(xwoba2025 - xwoba2024)
egen z_xwoba_diff = std(xwoba_diff)

egen z_skwoba2024 = std(skwoba2024)

corr z_skwoba2024 z_xwoba_diff
**you are here**
reg z_xwoba_diff z_skwoba2024

reg z_xwoba_diff z_skwoba2024 xwoba2024
reg xwoba2025 z_skwoba2024 xwoba2024

reg xwoba2025 ooe2024
egen z_ooe2024 = std(ooe2024)
reg xwoba_diff ooe2024

reg xwoba2025 skwoba2024
reg xwoba2025 xwoba2024
reg xwoba2025 skwoba2024 xwoba2024
