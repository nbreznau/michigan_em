# Urban Fiscal Crisis and Local Emergency Management: Tracking the Color Line in Michigan
## Replication Materials

[Preprint of paper](https://osf.io/k9ve7/)

## Datafiles

| Filename | Source | Explanation |
| ----- | ----- | -----|
| FIS RACE EM MAIN.xlsx | Authors qualitative research and Munetrix | Contains all cases of emergency management in Michigan from 2007-2013 and "Fiscal Indicator Scores" |
| DEC_00_SF3_DP3_with_ann.xlsx | Decennial US Census | Michigan population by Census track 060 for 2000 and 2010 |
| ACS_10_5YR_DP03_with_ann.xlsx | American Community Survey | Values for 2006-2013, used for interpolating race-percentages by census unit in interim years |
| em_rep.dta | Stata file with main analysis data | Worked up using the files 01_prep_FIS.do and 02_prep_ACS.do |

## Workflow

Replicators can start with the file 01_Descriptives.do to load the data and create the descriptive tables and figures. The anaysis was done in Mplus, and as we do not have an easy way to make this reproducible, all output files are available in the folder `/results/SEM` and these results have been hand transferred into Excel in the document `results/tbl3to5.xlsx`.


