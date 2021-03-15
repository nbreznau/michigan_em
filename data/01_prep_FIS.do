** FISCAL INDICATOR SCORE DATA **

*Nate Breznau, University of Bremen
*L. Owen Kirkpatrick, Southern Methodist University

*contact: breznau.nate@gmail.com

*********************************************
*Preparation

*Set your working directory

global DIR "C:/GitHub/michigan_em" 



*********************************************
*Fiscal Indicator Score Data

*SOURCE:
*Munetrix

*http://www.munetrix.com/Michigan/Municipalities

*Michigan Dept. of Treasury
*http://www.michigan.gov/treasury/0,4679,7-121-1751_51556-198770--,00.html

* Note that these data have manually added demographic variables, but we
* ignore these and instead use the ACS in 02_prep_ACS.do for the 
* sake of reproducibility

import excel "${DIR}/data/FIS RACE EM MAIN.xlsx", sheet("data") firstrow case(lower) clear
destring, replace
reshape long pwhite pblack fis fisg em pop, i(code) j(year)
recode em (1/3=1), gen(eml)
bysort code: egen pblack_m = mean(pblack)
gen pblack_c = pblack_m - pblack
gen fis_i = fis
replace fis_i = fisg if fis_i==.
bysort code: egen fis_m= mean(fis_i)
replace fis_i=fis_m if fis_i==.


save "${DIR}/data/fis_cleaned.dta", replace

