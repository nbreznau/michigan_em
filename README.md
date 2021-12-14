# Urban Fiscal Crisis and Local Emergency Management: Tracking the Color Line in Michigan

##### [Nate Breznau](https://sites.google.com/site/nbreznau/)
##### University of Bremen
##### breznau.nate@gmail.com
</br>

##### [L. Owen Kirkpatrick](https://www.smu.edu/Dedman/Academics/Departments/Sociology/People/Faculty/LucasOwenKirkpatrick)
##### Southern Methodist University
##### kirkpatrick@smu.edu

</br>

## Replication Materials

### Article

Forthcoming in *Issues in Race and Society: An Interdisciplinary Global Journal*

[Preprint of paper](https://osf.io/k9ve7/)

### Datafiles

| Filename | Source | Explanation |
| ----- | ----- | -----|
| FIS RACE EM MAIN.xlsx | Authors qualitative research and Munetrix | Contains all cases of emergency management in Michigan from 2007-2013 and "Fiscal Indicator Scores" |
| DEC_00_SF3_DP3_with_ann.xlsx | Decennial US Census | Michigan population by Census track 060 for 2000 and 2010 |
| ACS_10_5YR_DP03_with_ann.xlsx | American Community Survey | Values for 2006-2013, used for interpolating race-percentages by census unit in interim years |
| em_rep.dta | Stata file with main analysis data | Worked up using the files 01_prep_FIS.do and 02_prep_ACS.do |

## Workflow

Work done in Stata and Mplus.

Replicators can start with the file 01_Descriptives.do to load the data and create the descriptive tables and figures in Stata. 

The anaysis was done in Mplus, all output files are available in the folder `/results/SEM` and these results have been hand transferred into Excel in the document `results/tbl3to5.xlsx`.

### Highlights

#### Abstract

The  usage  of  emergency  management  by  United  States’  state-level  governments  to resolve  troubled  municipal  finances  increased  dramaticallyover  the  past  three  decades. Layoffs, school closings, pension renegotiations, and sale of public assets are the product of such policies, and these policies unevenly affect black residents. Recent legal decisions argue  this  is  an  innocent  byproduct  of  black  concentration  in  fiscally  distressed  cities. Thus, targeted emergency  intervention is colorblind in its application, and any  race-bias is  mere  statistical  discrimination  among  fiscally-challenged  areas.  We  investigate  this assertion,  asking  if  raciallyinequitable  outcomes  signal differential  impact  on,  or differential treatmentof black people. We investigate Michigan, the site of the country’s most  intensive  emergency  management  deployments.  Using  all  politically  incorporated units  in  Michigan,  2007-2013, we develop a counterfactual test using the state’s own fiscal distress scale and adjusting for percentage black and median household income of each  unit.  We  find  a  net  effect  of the percentage  of black  residents  on  the  likelihood  of emergency  management  after  adjusting  for  fiscal  distress.  If  correctly  specified,  our model  gives  evidence  that  racial  bias  was  a  factor  in  the  application  of  emergency management –that units in Michigan with similar fiscal distress levels were more likely to  get  emergencymanagement  if  they  had  higher  black  populations,  all  else  equal.  We cannot  identify  the  specific  micro-mechanisms  at  play,  meaning  we  cannot  conclude  if any  actors in the process had race-biased intentions, and we discuss the meaning of our findings in light of this.

#### Descriptive and Analytical Results

![Fig 2a](..main/results/Fig2a.png "Figure 2a")
