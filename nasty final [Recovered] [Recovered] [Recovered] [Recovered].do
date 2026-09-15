import delimited "\\apporto.com\dfs\WUSTL\Users\bagratz_wustl\Desktop\nasty2.csv", clear
summarize fastball_avg_break
egen z_fastballbreak_score = std(fastball_avg_break)

summarize fastball_avg_speed
egen z_fastballspeed_score = std(fastball_avg_speed)
generate z_fast = z_fastballbreak_score + z_fastballspeed_score

summarize breaking_avg_break
egen z_breakingbreak = std(breaking_avg_break)

summarize breaking_avg_speed
egen z_breakingspeed = std(breaking_avg_speed)
generate z_breaking = z_breakingbreak + z_breakingspeed

summarize offspeed_avg_break
egen z_offspeedbreak = std(offspeed_avg_break)

summarize offspeed_avg_speed
egen z_offspeedspeed = std(offspeed_avg_speed)
generate z_offspeed = z_offspeedbreak+z_offspeedspeed

generate weighted_fast = n_fastball_formatted*z_fast
generate weighted_breaking = n_breaking_formatted*z_breaking
generate weighted_offspeed = n_offspeed_formatted*z_offspeed

generate stuff = weighted_breaking + weighted_fast + weighted_offspeed
egen z_stuff = std(stuff)
*******************************************************
reg whiff_percent stuff

generate quality_pitch = edge_percent - meatball_percent
summarize quality_pitch
egen z_command = std(quality_pitch)
reg xwoba z_stuff z_command
******************************************************
correlate poorlytopped_percent poorlyunder_percent poorlyweak_percent
reg xwoba poorlyunder_percent poorlyweak_percent
reg xwoba poorlytopped_percent poorlyweak_percent

reg xwoba sweet_spot_percent barrel_batted_rate solidcontact_percent
correlate poorlytopped_percent poorlyunder_percent poorlyweak_percent sweet_spot_percent barrel_batted_rate solidcontact_percent

egen z_poor = std(poorlytopped_percent)
egen z_barrel = std(barrel_batted_rate)

reg xwoba z_stuff z_command z_poor z_barrel
********************************************************
generate kbb = k_percent - bb_percent
reg xwoba stuff quality_pitch kbb
summarize kbb
egen z_kbb = std(kbb)
reg xwoba kbb
reg xwoba stuff quality_pitch whiff_percent swords
reg k_percent whiff_percent swords
********************************************************
egen z_whiff = std(whiff_percent)

reg xwoba z_stuff z_poor z_command z_barrel z_whiff z_kbb

correlate z_stuff z_whiff
*******************************************************
reg xwoba z_swing_miss_percent z_swing_percent oz_contact_percent oz_swing_miss_percent oz_swing_percent out_zone_percent

reg k_percent z_swing_miss_percent z_swing_percent oz_contact_percent oz_swing_miss_percent oz_swing_percent out_zone_percent

correlate whiff_percent z_swing_miss_percent oz_swing_miss_percent

egen z_chase = std(oz_swing_percent)
egen z_inzonewhiff = std(z_swing_miss_percent)
reg xwoba z_chase z_inzonewhiff z_command z_poor z_barrel z_stuff z_kbb z_whiff

generate z_control = z_kbb
generate z_contact = z_barrel + z_poor
generate z_deception = z_whiff + z_inzonewhiff + z_chase 

reg xwoba z_stuff z_control z_contact z_deception

corr poorlytopped_percent poorlyunder_percent poorlyweak_percent flareburner_percent

reg xwoba poorlytopped_percent poorlyunder_percent poorlyweak_percent flareburner_percent
*******************************
egen z_poorlytopped = std(poorlytopped_percent)
egen z_poorlyunder = std(poorlyunder_percent)
egen z_poorlyweak = std(poorlyweak_percent)
egen z_flareburn = std(flareburner_percent)
reg xwoba z_poorlyweak z_poorlytopped z_flareburn z_poorlyunder z_kbb z_barrel
***********************************************

generate contact_metric11 = (-.0127824*z_poorlytopped) + (-.0128773*z_poorlyunder) + (-.0017922*z_poorlyweak)

egen z_contact_final1 = std(contact_metric11)

reg xwoba z_contact_final1 z_kbb z_barrel z_flareburn

estat vif

corr z_kbb z_inzonewhiff z_chase z_whiff xwoba

generate stat_final1 = -1*((z_contact_final*.0064715) + (-.0196713*z_kbb) + (0.0085431*z_barrel) + (0.0032008*z_flareburn))
egen z_stat_final1 = std(stat_final1)
egen z_xwoba = std(xwoba)
replace z_xwoba = -1*z_xwoba

generate diffstat_final1 = z_xwoba - z_stat_final1
egen z_diffstat_final1 = std(diffstat_final1)

sort diffstat_final1
***************************
reg xwoba z_contact_final
reg xwoba z_contact_final z_kbb
reg xwoba z_contact_final z_barrel
reg xwoba z_contact_final z_kbb z_barrel
***********************************************

reg xwoba z_contact_final z_kbb z_barrel z_flareburn

reg xwoba z_poorlyweak z_poorlytopped z_poorlyunder z_kbb z_barrel

corr z_poorlytopped z_poorlyunder z_poorlyweak

reg z_xwoba z_poorlytopped z_poorlyunder z_kbb z_barrel

generate caps = ((.5962999*z_poorlytopped) + (.6124874 *z_poorlyunder) + (.7026914*z_kbb) + (-.2830242 *z_barrel))
egen z_caps = std(caps)
generate skill_gap = z_xwoba - z_caps
sort skill_gap
gsort -caps
reg xwoba kbb
gen kdivbb = k_percent / bb_percent
gen kbb_diff = abs(kdivbb - kbb)
sort kbb_diff
sort bb_percent
egen z_kdivbb = std(kdivbb)
gen z_kbbdiff = abs(z_kbb - z_kdivbb)
sort z_kbbdiff