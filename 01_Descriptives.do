*Nate Breznau, University of Bremen
*L. Owen Kirkpatrick, Southern Methodist University

*contact: breznau.nate@gmail.com

*********************************************
*Preparation

*packages needed
*ssc install estout

*Set your working directory

global wdir "C:/GitHub/michigan_em" 

* Load data (see /data folder for prep files)
use "${wdir}/data/em_rep.dta", clear


**********************************************
*Table 1. EM by race

*Generate white, black and other population (in k)
gen wpop = (pwhite/100)*pop
gen bpop = (pblack/100)*pop
gen opop = ((100-pwhite-pblack)/100)*pop

gen epopw = (eme*wpop)
gen epopt = (eme*pop)
gen epopb = (eme*bpop)
gen epopo = (eme*opop)


*Output to Excel
putexcel set "${wdir}/results/tbl1.xlsx", replace
putexcel B1 = "All"
putexcel C1 = "White"
putexcel E1 = "Black"
putexcel G1 = "Other"
putexcel A2 = "Total Population (in thousdands)"
putexcel A3 = "Emergency Management (any during 2007-13)"
putexcel A4 = "Percent Affected"

*Total Population by Race 2012
total pop if year == 2012
matrix a = e(b)
local total a[1,1]/1000

total wpop if year == 2012
matrix b = e(b)
local white b[1,1]/1000

total bpop if year == 2012
matrix c = e(b)
local black c[1,1]/1000

total opop if year == 2012
matrix d = e(b)
local other d[1,1]/1000

putexcel B2 = `total', nformat(number)
putexcel C2 = `white', nformat(number)
putexcel E2 = `black', nformat(number)
putexcel G2 = `other', nformat(number)

*Total Population under EM at some point (2007-2013)
total epopt if year == 2012
matrix e = e(b)
local etotal e[1,1]/1000
total epopw if year == 2012
matrix f = e(b)
local ewhite f[1,1]/1000
total epopb if year == 2012
matrix g = e(b)
local eblack g[1,1]/1000
total epopo if year == 2012
matrix h = e(b)
local eother h[1,1]/1000

putexcel B3 = `etotal', nformat(number)
putexcel C3 = `ewhite', nformat(number)
putexcel E3 = `eblack', nformat(number)
putexcel G3 = `eother', nformat(number)

*Column Percentages
putexcel B4 = ((`etotal')/(`total')), nformat(percent) bold
putexcel C4 = ((`ewhite')/(`white')), nformat(percent) bold
putexcel E4 = ((`eblack')/(`black')), nformat(percent) bold
putexcel G4 = ((`eother')/(`other')), nformat(percent) bold

putexcel D2 = ((`white')/(`total')), nformat(percent)
putexcel F2 = ((`black')/(`total')), nformat(percent)
putexcel H2 = ((`other')/(`total')), nformat(percent)

putexcel D3 = ((`ewhite')/(`etotal')), nformat(percent)
putexcel F3 = ((`eblack')/(`etotal')), nformat(percent)
putexcel H3 = ((`eother')/(`etotal')), nformat(percent)


putexcel close


*******************************************************
* Table 2. Descriptives

*take log income
gen medhinc_ln = ln(medhinc)

estpost summarize eml fis_i pblack medhinc_ln pwhite if pop>1500

esttab . using "${wdir}/results/tbl2.csv", cells("count mean sd min max") replace 



*******************************************************
* Figure 3


label var pblack "Percent Black Population"
set seed 90125
twoway (scatter fis pblack  if eml == 0, jitter(8) msize(.3) mcolor(gray*2)) ///
(scatter fis pblack if eml == 1, msize(1.2) msymbol(D) jitter(2) mcolor(maroon)) ///
, graphregion(color(white)) bgcolor(white) legend(order(2 "Emergency Management" 1 "Self-Governance")) 

graph export "${wdir}/results/fig3.png", width(800) height(600) replace



*******************************************************
*MPlus
drop if pop<1500
drop if medhinc==.
gen lnminc = ln(medhinc)

* Center use variables
sum eml fis_i pblack lnminc pwhite
replace fis_i = fis_i-1.418151
replace pblack = pblack-3.604963
replace lnminc=lnminc-3.885343
replace pwhite = pwhite-91.78639
keep code em_ever pwhite pblack eml fis_i fis_m medhinc lnminc
stata2mplus using "${wdir}/SEM/emcause, replace


* rate of change of race is negligible within units
xtmixed pblack || code:
xtmrho
xtmixed fis_i || code:
xtmrho
xtmixed pwhite || code:
xtmrho

*rho’s pblack = 99.5%, fis = 57.3%, pwhite= 99.5%

