** AMERICAN COMMUNITY SURVEY DATA **


*Nate Breznau, University of Bremen
*L. Owen Kirkpatrick, Southern Methodist University

*contact: breznau.nate@gmail.com

*********************************************
*Preparation

*Set your working directory

global wdir "C:/GitHub/michigan_em" 


*********************************************
*Decennial Census Data 2010

import excel "${wdir}/data/DEC_00_SF3_DP3_with_ann.xlsx", sheet("variables") firstrow case(lower) clear
keep esriid dn
sort esriid
save "${wdir}/data/workingcensus.dta", replace


*********************
*Combine with FIS data

*Must have run 01_prep_FIS.do first
use "${wdir}/data/fis_cleaned.dta", clear

replace esriid=2602179740 if esriid==1
sort esriid

merge esriid using "${wdir}/data/workingcensus.dta"
sum dn

*********************
*Household income
clonevar medhinc00=dn
replace medhinc00 = medhinc00/1000
keep code-fis_m medhinc00


preserve



*********************************************
*American Community Survey Data 2010
import excel "${wdir}/data/ACS_10_5YR_DP03_with_ann.xlsx", sheet("ACS_10_5YR_DP03_with_ann.csv") firstrow clear
destring HC01_VC85, force replace
clonevar esriid = GEOid2

keep esriid HC01_VC85
sort esriid
save "${wdir}/data/ACS5yr2010medhinc.dta", replace


*********************************************
*Merge data

restore
sort esriid

merge esriid using "${wdir}/data/ACS5yr2010medhinc.dta"
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



*clean up df
drop if medhinc==.
*interpolation led to slight jumping of boundaries
replace pblack = 100 if pblack > 100
replace pwhite = 100 if pwhite > 100
replace pwhite = 0 if pwhite < 0
replace pblack=0 if pblack<0
gen eme = em_ever
replace eme = 1 if eme > 1
replace em_ever = em

label var em_ever "Type of EM"
label define em_ever 1 "EM" 2 "EM including schools" 3 "Consent agreement"
label val em_ever em_ever

label var code "Census ID"
label var year "Year"
label var muni "Unit Name"
label var subtype "Type of Unit"
label var incounty "County Name"

label var pwhite "Percent White Pop"
label var pblack "Percent Black Pop"

label var fis "Fiscal Indicator Score"
label var fis_i "Fiscal Indicator Score, interpolated"
label var pop "Population, from Census and ACS"
label var eme "Under EM in any year from 2007 to 2013"
label var eml "Under EM (t+1)"

label var medhinc "Median Household Income, in k $"
label var fis_m "Mean FIS from 2008 to 2013"

order code year muni subtype incounty eml eme em_ever fis fis_i fis_m pblack pwhite pop medhinc
keep code year muni subtype incounty eml eme em_ever fis fis_i fis_m pblack pwhite pop medhinc


save "${wdir}/data/em_rep.dta", replace
