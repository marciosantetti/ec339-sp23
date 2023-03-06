

clear

use pwt_select




gen lrdgpna = log(rgdpna)
gen lccon = log(ccon)
gen lemp = log(emp)


reg lrdgpna pop emp ck ccon

vif


reg lrdgpna lemp ck lccon 

vif
