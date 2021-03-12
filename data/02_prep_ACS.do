** AMERICAN COMMUNITY SURVEY DATA **


*Nate Breznau, University of Bremen
*L. Owen Kirkpatrick, Southern Methodist University

*contact: breznau.nate@gmail.com

*********************************************
*Preparation

*Set your working directory

global wdir "C:/GitHub/em_michigan/" 


*********************************************
*Decennial Census Data 2010

import excel "${DIR}/data/DEC_00_SF3_DP3_with_ann.xlsx", sheet("variables") firstrow case(lower) clear
keep esriid dn
sort esriid
save "${DIR}/data/workingcensus.dta", replace


*********************
*Combine with FIS data

*Must have run 01_prep_FIS.do first
use "${DIR}/data/fis_cleaned.dta", clear

replace esriid=2602179740 if esriid==1
sort esriid

merge esriid using "${DIR}/data/workingcensus.dta"
sum dn

*********************
*Household income
clonevar medhinc00=dn
replace medhinc00 = medhinc00/1000
keep code-fis_m medhinc00


preserve



*********************************************
*American Community Survey Data 2010
import excel "${DIR}/data/ACS_10_5YR_DP03_with_ann.xlsx", sheet("ACS_10_5YR_DP03_with_ann.csv") firstrow clear
destring HC01_VC85, force replace
clonevar esriid = GEOid2

keep esriid HC01_VC85
sort esriid
save "${DIR}/data/ACS5yr2010medhinc.dta", replace


*********************************************
*Merge data

restore
sort esriid

merge esriid using "${DIR}/data/ACS5yr2010medhinc.dta"
clonevar medhinc10 = HC01_VC85
replace medhinc10 = medhinc10/1000
replace medhinc00 = . if medhinc00==0
drop if em_ever==.
gen medhincC = medhinc10-medhinc00
sum medhincC
replace medhincC=0 if medhincC==.
drop if year==2000
drop if year==2005
sum medhincC if pop>1500
gen cf = -1*(medhincC/10)
gen medhinc=medhinc10
replace medhinc=medhinc+cf if year==2009
replace medhinc=medhinc+(2*cf) if year==2008
replace medhinc=medhinc+(3*cf) if year==2007
replace medhinc=medhinc+(4*cf) if year==2006
replace medhinc=medhinc-cf if year==2011
replace medhinc=medhinc-(2*cf) if year==2012

replace pblack=0 if pblack<0

save "${DIR}/data/em_rep.dta", replace
