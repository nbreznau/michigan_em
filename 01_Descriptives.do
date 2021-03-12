*Nate Breznau, University of Bremen
*L. Owen Kirkpatrick, Southern Methodist University

*contact: breznau.nate@gmail.com

*********************************************
*Preparation

*Set your working directory

global wdir "C:/GitHub/em_michigan/" 

* Load data (see /data folder for prep files)
use "${DIR}/data/em_rep.dta", clear


**********************************************
*Table 1. EM by race

*Generate white, black and other population (in k)
gen wpop = (pwhite/100)*pop
gen bpop = (pblack/100)*pop
gen opop = ((100-pwhite-pblack)/100)*pop

gen eme = 0

*Ever under EM in that unit
replace eme = 1 if em_ever>0

gen epopw = (eme*wpop)
gen epopt = (eme*pop)
gen epopb = (eme*bpop)
gen epopo = (eme*opop)


*Output to Excel
putexcel set "${DIR}/results/tbl1.xlsx", replace
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




*******************************************************8

*** Not yet processed 12-Mar-21

drop if medhinc==.




*for some reason em_ever does not include Inkster
sort code
tabdisp code, cellvar(muni)
bysort code:egen emev=mean(eml)
tab muni if emev>0
replace emev=1 if emev>0
table code if eml==1, c(m pblack m fis_i)

table code if eml==0 & emev==1, c(m pblack m fis_i)

 
logit eml fis_i if pop>1500, cluster(code)
est store f1

logit eml fis_i pblack if pop>1500, cluster(code)
est store b1
logit, or
logit eml fis_i pblack if pop>1500
margins, at(pblack=(0(5)100))
margins, at(pblack=(0(5)100)) level(90)
logit eml fis_i pwhite if pop>1500, cluster(code)
est store w1
logit, or
*confidence intervals are left unbiased due to the small sample size, kind of a mini penalized likelihood correction as the ED event is so rare
logit eml fis_i pwhite if pop>1500
margins, at(pwhite=(0(5)100))
margins, at(pwhite=(0(5)100)) level(90)


logit eml fis_i medhinc if pop>1500, cluster(code)
est store hinc1
logit eml fis_i medhinc pblack if pop>1500, cluster(code)
est store b2
logit eml fis_i medhinc pwhite if pop>1500, cluster(code)
est store w2

*Table 3

estimates table f1 b1 hinc1 b2, stats(N r2_p aic) star(.05 .01 .001) b(%9.2f)

 estimates table f1 b1 hinc1 b2, stats(N r2_p aic) star(.05 .01 .001) b(%9.2f) eform

 
 
*MPlus

use "C:\data\Detroit\analysis.dta", clear
drop if pop<1500
drop if medhinc==.
gen lnminc = ln(medhinc)
recode pblack (100/101=100)
recode pwhite (-4/0=0)(100/101=100)
sum eml fis_i pblack lnminc pwhite
replace fis_i = fis_i-1.418151
replace pblack = pblack-3.604963
replace lnminc=lnminc-3.885343
recode pwhite (-4/0=0)(100/101=100)
replace pwhite = pwhite-91.78639
keep code em_ever pwhite pblack eml fis_i fis_m medhinc lnminc
stata2mplus using C:\data\Detroit\emcause, replace

*or runmplus in stata (make sure things are installed and directory has write permission (not run on a server, e.g.)
cd C:\data\Detroit\
runmplus eml fis_i pblack lnminc, categorical(eml) model(fis_i on pblack lnminc; eml on fis_i pblack) estimator(ML)
*ICC / RHO

xtmixed pblack || code:
xtmrho
xtmixed fis_i || code:
xtmrho
xtmixed pwhite || code:
xtmrho

*rho’s pblack = 99.5%, fis = 57.3%, pwhite= 99.5%
MPlus code

*Variance of y*
*M1
logit eml fis_i
fitstat
*result 5.37
*M2
logit eml fis_i pblack
fitstat
*result 4.52
*This gives the variance of y* which is equal to the variance of y* + pi^2/3(the logistic distribution variance)
*Sensitivity
*Firthlogit
*Results come out the same
logit eml fis_i pblack medhinc
firthlogit eml fis_i pblack medhinc

Nate—
     The model is identified once you fix the residual variance (“theta”). Let the factor variance be “free” and ignore it—its value will be equal to:
Variance(X2) – residual variance(X2)
It will change as you choose different values for the residual variance of X2. You could set the factor variance to this value, but then you would have to keep track of it as you change the residual variance of X2.
The number you need to worry about is the variance of X2. Set the residual variance of X2 as a percent of X2’s total variance. Then  you can scale up this residual variance until either (a) you get what you want, or (b) the model starts producing nonsense estimates, or just fails.
--Ed Rigdon

.	sum eml fis_i	pblack

	Variable	Obs	Mean	Std. Dev.	Min	Max
						
	eml	6,938	.0066302	.0811612	0	1
	fis_i	6,938	1.418151	1.334057	0	9
	pblack	6,938	3.604963	9.8918		0	100.18

*variance of fis = 
display (1.334057)^2
display 1.7797081*.9
display 1.7797081*.8
display 1.7797081*.7
display 1.7797081*.6
display 1.7797081*.5
display 1.7797081*.4
display 1.7797081*.3
display 1.7797081*.2
display 1.7797081*.1

 

