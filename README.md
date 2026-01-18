
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

All you need to specify is how many patients. Let’s say you want data
generated for N=5 patients.

``` r
library(oncraw)

# Generate raw domains for 5 patients 
domains <- genRaw(N=5)

# DM domain: demographic data 
dm <- domains$dm
dm
#>    SUBJID DSCONT      ENRDT  DLCRT  SEX              ETHNICITY  RACE
#> 1 SUBJID1    Yes 2026-02-26 400 mg Male Not Hispanic or Latino White
#> 2 SUBJID2    Yes 2026-09-03 300 mg Male     Hispanic or Latino White
#> 3 SUBJID3    Yes 2026-01-22 300 mg Male Not Hispanic or Latino White
#> 4 SUBJID4     No 2026-08-28 200 mg Male     Hispanic or Latino White
#> 5 SUBJID5    Yes 2026-03-29 200 mg Male Not Hispanic or Latino White

# TU domain: tumor evaluation data
tu <- domains$tu
head(tu)
#>     SUBJID      ENRDT  DLCRT           VISIT      TUCAT TULNKID     TULOC
#> 14 SUBJID1 2026-02-26 400 mg       Screening Non-Target     NT1      Lung
#> 1  SUBJID1 2026-02-26 400 mg       Screening     Target      T1  Prostate
#> 2  SUBJID1 2026-02-26 400 mg       Screening     Target      T2     Other
#> 3  SUBJID1 2026-02-26 400 mg       Screening     Target      T3    Larynx
#> 4  SUBJID1 2026-02-26 400 mg       Screening     Target      T4 Esophagus
#> 22 SUBJID1 2026-02-26 400 mg Post-Baseline 1 Non-Target     NT1      Lung
#>         TUDAT                                 TUDIAMI     TUSTAT   TUDIAM
#> 14 2026-02-28                                    <NA>       <NA>       NA
#> 1  2026-02-28 Longest Diameter for Extranodal Lesions Measurable 49.38133
#> 2  2026-02-28 Longest Diameter for Extranodal Lesions Measurable 21.15702
#> 3  2026-02-28 Longest Diameter for Extranodal Lesions Measurable 53.60274
#> 4  2026-02-28 Longest Diameter for Extranodal Lesions Measurable 37.69091
#> 22 2026-04-11                                    <NA>       <NA>       NA
#>    TUEVAL
#> 14   <NA>
#> 1    <NA>
#> 2    <NA>
#> 3    <NA>
#> 4    <NA>
#> 22 Absent

# RS domain: response assessment data
rs <- domains$rs
head(rs)
#>    SUBJID      ENRDT  DLCRT           VISIT      RSDAT TRGRESP      NTRGRESP
#> 1 SUBJID1 2026-02-26 400 mg Post-Baseline 1 2026-04-11      NE            CR
#> 2 SUBJID1 2026-02-26 400 mg Post-Baseline 2 2026-05-22      SD NON-CR/NON-PD
#> 3 SUBJID1 2026-02-26 400 mg Post-Baseline 3 2026-07-03      NE NON-CR/NON-PD
#> 4 SUBJID2 2026-09-03 300 mg Post-Baseline 1 2026-10-20      SD            CR
#> 5 SUBJID2 2026-09-03 300 mg Post-Baseline 2 2026-11-30      PR NON-CR/NON-PD
#> 6 SUBJID3 2026-01-22 300 mg Post-Baseline 1 2026-03-10      SD NON-CR/NON-PD
#>   NEW OVRLRESP
#> 1   0       NE
#> 2   0       SD
#> 3   1       PD
#> 4   0       SD
#> 5   1       PD
#> 6   0       SD

# AE domain: adverse event data
ae <- domains$ae
head(ae)
#>    SUBJID      ENRDT  DLCRT AETERM       AEREL         AEOUT     AESTDT AEONGO
#> 2 SUBJID1 2026-02-26 400 mg   AE61 Not Related     Recovered 2026-03-04      N
#> 3 SUBJID1 2026-02-26 400 mg   AE46 Not Related    Recovering 2026-03-06      Y
#> 4 SUBJID1 2026-02-26 400 mg    AE4 Not Related     Recovered 2026-03-09      N
#> 5 SUBJID1 2026-02-26 400 mg   AE11 Not Related    Recovering 2026-03-10      Y
#> 6 SUBJID1 2026-02-26 400 mg   AE16 Not Related     Recovered 2026-03-15      N
#> 7 SUBJID1 2026-02-26 400 mg   AE94 Not Related Not Recovered 2026-03-28      Y
#>       AEENDT AETOXGR AESER            AEACN
#> 2 2026-03-17 Grade 2     Y   Drug Withdrawn
#> 3       <NA> Grade 1     N Dose Not Changed
#> 4 2026-03-11 Grade 1     N     Dose Reduced
#> 5       <NA> Grade 3     N Dose Not Changed
#> 6 2026-03-23 Grade 1     Y Dose Not Changed
#> 7       <NA> Grade 5     N Dose Interrupted

# DD domain: death data (returns NULL if no deaths occurred)
dd <- domains$dd
head(dd)
#>    SUBJID      ENRDT  DLCRT     DTHDAT             DTHCAUS
#> 1 SUBJID1 2026-02-26 400 mg 2026-09-26 Disease Progression
#> 2 SUBJID2 2026-09-03 300 mg 2027-01-22 Disease Progression

# DS domain: disposition data (returns NULL if no disposition records exist)
ds <- domains$ds
head(ds)
#>    SUBJID      ENRDT  DLCRT            DSCAT       DSDECOD      DSDAT
#> 1 SUBJID1 2026-02-26 400 mg End of Treatment Adverse Event 2026-03-04
#> 2 SUBJID1 2026-02-26 400 mg     End of Study         Death 2026-09-26
#> 3 SUBJID2 2026-09-03 300 mg End of Treatment Adverse Event 2026-10-29
#> 4 SUBJID2 2026-09-03 300 mg     End of Study         Death 2027-01-22
#> 5 SUBJID3 2026-01-22 300 mg End of Treatment Adverse Event 2026-03-28
#> 6 SUBJID4 2026-08-28 200 mg End of Treatment Adverse Event 2027-01-01

# EX domain: exposure data
ex <- domains$ex
head(ex)
#>    SUBJID      ENRDT  DLCRT    EXTRT     EXSTDT EXPDOSE EXADOSE EXADJ EXAREAS
#> 1 SUBJID1 2026-02-26 400 mg New Drug 2026-02-26     200     200     N    <NA>
#> 2 SUBJID2 2026-09-03 300 mg New Drug 2026-09-03     200     200     N    <NA>
#> 3 SUBJID2 2026-09-03 300 mg New Drug 2026-09-24     200     200     N    <NA>
#> 4 SUBJID2 2026-09-03 300 mg New Drug 2026-10-15     200     200     N    <NA>
#> 5 SUBJID3 2026-01-22 300 mg New Drug 2026-01-22     200     200     N    <NA>
#> 6 SUBJID3 2026-01-22 300 mg New Drug 2026-02-12     200     200     N    <NA>
```
