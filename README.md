
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oncraw

<!-- badges: start -->
<!-- badges: end -->

The oncraw package provides an easy-to-use tool for generating raw data
domains (pre-SDTM clinical data) for oncology trials based on Case
Report Forms (CRFs). The simulated data are designed to closely resemble
real-world oncology trial data and can be used by researchers as
training datasets to develop and test AI-enabled workflows for data
processing and TFL automation. The annotated CRFs are stored in the
/acrf folder.

## Installation

You can install the development version of oncraw from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("eric-zhang16/oncraw")
```

## Example

All you need to specify is how many patients. Assume you want data
generated for N=5 patients.

``` r
library(oncraw)

# Generate raw domains for 5 patients 
domains <- genRaw(N=5)

# DM domain: demographic data 
dm <- domains$dm
dm
#>    SUBJID DSCONT      ENRDT  DLCRT    SEX              ETHNICITY
#> 1 SUBJID1    Yes 2026-05-28 200 mg Female Not Hispanic or Latino
#> 2 SUBJID2    Yes 2026-04-30 400 mg   Male     Hispanic or Latino
#> 3 SUBJID3    Yes 2026-06-01 400 mg   Male Not Hispanic or Latino
#> 4 SUBJID4    Yes 2026-06-04 200 mg Female     Hispanic or Latino
#> 5 SUBJID5    Yes 2026-03-22 200 mg   Male Not Hispanic or Latino
#>                               RACE
#> 1                            Asian
#> 2                            White
#> 3                            White
#> 4                            Asian
#> 5 American Indian or Alaska Native

# TU domain: tumor evaluation data
tu <- domains$tu
head(tu)
#>      SUBJID      ENRDT  DLCRT           VISIT      TUCAT TULNKID       TULOC
#> 110 SUBJID1 2026-05-28 200 mg       Screening Non-Target     NT1       Other
#> 1   SUBJID1 2026-05-28 200 mg       Screening     Target      T1 Lymph Nodes
#> 2   SUBJID1 2026-05-28 200 mg       Screening     Target      T2        Lung
#> 3   SUBJID1 2026-05-28 200 mg       Screening     Target      T3    Pancreas
#> 4   SUBJID1 2026-05-28 200 mg       Screening     Target      T4      Larynx
#> 23  SUBJID1 2026-05-28 200 mg Post-Baseline 1 Non-Target     NT1       Other
#>          TUDAT                                 TUDIAMI     TUSTAT   TUDIAM
#> 110 2026-05-29                                    <NA>       <NA>       NA
#> 1   2026-05-29              Short Axis for Lymph Nodes Measurable 15.00000
#> 2   2026-05-29 Longest Diameter for Extranodal Lesions Measurable 21.06346
#> 3   2026-05-29 Longest Diameter for Extranodal Lesions Measurable 25.52246
#> 4   2026-05-29 Longest Diameter for Extranodal Lesions Measurable 33.24031
#> 23  2026-07-08                                    <NA>       <NA>       NA
#>      TUEVAL
#> 110    <NA>
#> 1      <NA>
#> 2      <NA>
#> 3      <NA>
#> 4      <NA>
#> 23  Present

# RS domain: response assessment data
rs <- domains$rs
head(rs)
#>    SUBJID      ENRDT  DLCRT           VISIT      RSDAT TRGRESP      NTRGRESP
#> 1 SUBJID1 2026-05-28 200 mg Post-Baseline 1 2026-07-08      SD NON-CR/NON-PD
#> 2 SUBJID1 2026-05-28 200 mg Post-Baseline 2 2026-08-18      SD NON-CR/NON-PD
#> 3 SUBJID1 2026-05-28 200 mg Post-Baseline 3 2026-09-30      NE            CR
#> 4 SUBJID1 2026-05-28 200 mg Post-Baseline 4 2026-11-14      NE NON-CR/NON-PD
#> 5 SUBJID1 2026-05-28 200 mg Post-Baseline 5 2026-12-27      SD NON-CR/NON-PD
#> 6 SUBJID2 2026-04-30 400 mg Post-Baseline 1 2026-06-14      NE NON-CR/NON-PD
#>   NEW OVRLRESP
#> 1   0       SD
#> 2   0       SD
#> 3   0       NE
#> 4   0       NE
#> 5   0       SD
#> 6   1       PD

# AE domain: adverse event data
ae <- domains$ae
head(ae)
#>     SUBJID      ENRDT  DLCRT AETERM       AEREL         AEOUT     AESTDT AEONGO
#> 2  SUBJID1 2026-05-28 200 mg   AE90 Not Related     Recovered 2026-06-08      N
#> 3  SUBJID1 2026-05-28 200 mg   AE85 Not Related Not Recovered 2026-06-09      N
#> 4  SUBJID1 2026-05-28 200 mg   AE12     Related    Recovering 2026-06-27      Y
#> 5  SUBJID1 2026-05-28 200 mg   AE93     Related     Recovered 2026-07-07      N
#> 21 SUBJID2 2026-04-30 400 mg   AE79 Not Related    Recovering 2026-05-04      Y
#> 31 SUBJID2 2026-04-30 400 mg   AE39 Not Related Not Recovered 2026-05-08      N
#>        AEENDT AETOXGR AESER            AEACN
#> 2  2026-06-25 Grade 2     Y Dose Not Changed
#> 3  2026-06-11 Grade 1     Y   Drug Withdrawn
#> 4        <NA> Grade 2     N Dose Not Changed
#> 5  2026-07-29 Grade 4     Y Dose Not Changed
#> 21       <NA> Grade 2     N Dose Not Changed
#> 31 2026-05-12 Grade 3     N Dose Not Changed

# DD domain: death data (returns NULL if no deaths occurred)
dd <- domains$dd
head(dd)
#>    SUBJID      ENRDT  DLCRT     DTHDAT             DTHCAUS
#> 1 SUBJID4 2026-06-04 200 mg 2026-10-19 Disease Progression

# DS domain: disposition data (returns NULL if no disposition records exist)
ds <- domains$ds
head(ds)
#>    SUBJID      ENRDT  DLCRT            DSCAT             DSDECOD      DSDAT
#> 1 SUBJID1 2026-05-28 200 mg End of Treatment       Adverse Event 2026-06-09
#> 2 SUBJID2 2026-04-30 400 mg End of Treatment Progressive Disease 2026-06-14
#> 3 SUBJID3 2026-06-01 400 mg End of Treatment       Adverse Event 2026-06-10
#> 4 SUBJID4 2026-06-04 200 mg End of Treatment       Adverse Event 2026-08-03
#> 5 SUBJID4 2026-06-04 200 mg     End of Study               Death 2026-10-19
#> 6 SUBJID5 2026-03-22 200 mg End of Treatment Progressive Disease 2026-06-18

# EX domain: exposure data
ex <- domains$ex
head(ex)
#>    SUBJID      ENRDT  DLCRT    EXTRT     EXSTDT EXPDOSE EXADOSE EXADJ
#> 1 SUBJID1 2026-05-28 200 mg New Drug 2026-05-28     200     100     Y
#> 2 SUBJID2 2026-04-30 400 mg New Drug 2026-04-30     200     200     Y
#> 3 SUBJID2 2026-04-30 400 mg New Drug 2026-05-21     150     150     N
#> 4 SUBJID2 2026-04-30 400 mg New Drug 2026-06-11     150     150     N
#> 5 SUBJID3 2026-06-01 400 mg New Drug 2026-06-01     200     200     N
#> 6 SUBJID4 2026-06-04 200 mg New Drug 2026-06-04     200     160     Y
#>             EXAREAS
#> 1 Dose Interruption
#> 2      Dose Reduced
#> 3              <NA>
#> 4              <NA>
#> 5              <NA>
#> 6 Dose Interruption
```
