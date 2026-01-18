
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oncraw

<!-- badges: start -->
<!-- badges: end -->

The oncraw package provides an easy-to-use tool for generating raw data
domains (pre-SDTM clinical data) for oncology trials based on Case
Report Forms (CRFs). The simulated data are designed to closely resemble
real-world oncology trial data and can be used by researchers as
training datasets to develop and test AI-enabled workflows for data
processing and TFL automation.

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
#>    SUBJID DSCONT      ENRDT  DLCRT    SEX              ETHNICITY
#> 1 SUBJID1    Yes 2026-05-29 300 mg Female           Not Reported
#> 2 SUBJID2    Yes 2026-02-06 200 mg Female Not Hispanic or Latino
#> 3 SUBJID3    Yes 2026-08-03 400 mg Female Not Hispanic or Latino
#> 4 SUBJID4     No 2026-06-12 400 mg   Male Not Hispanic or Latino
#> 5 SUBJID5    Yes 2026-07-19 200 mg Female     Hispanic or Latino
#>                               RACE
#> 1                            White
#> 2                            White
#> 3 American Indian or Alaska Native
#> 4        Black or African American
#> 5                            White

# TU domain: tumor evaluation data
tu <- domains$tu
head(tu)
#>      SUBJID      ENRDT  DLCRT           VISIT      TUCAT TULNKID     TULOC
#> 14  SUBJID1 2026-05-29 300 mg       Screening Non-Target     NT1      Bone
#> 22  SUBJID1 2026-05-29 300 mg       Screening Non-Target     NT2    Larynx
#> 32  SUBJID1 2026-05-29 300 mg       Screening Non-Target     NT3 Esophagus
#> 1   SUBJID1 2026-05-29 300 mg       Screening     Target      T1 Esophagus
#> 2   SUBJID1 2026-05-29 300 mg       Screening     Target      T2  Prostate
#> 211 SUBJID1 2026-05-29 300 mg Post-Baseline 1 Non-Target     NT1      Bone
#>          TUDAT                                 TUDIAMI     TUSTAT   TUDIAM
#> 14  2026-05-31                                    <NA>       <NA>       NA
#> 22  2026-05-31                                    <NA>       <NA>       NA
#> 32  2026-05-31                                    <NA>       <NA>       NA
#> 1   2026-05-31 Longest Diameter for Extranodal Lesions Measurable 34.83875
#> 2   2026-05-31 Longest Diameter for Extranodal Lesions Measurable 42.00929
#> 211 2026-07-14                                    <NA>       <NA>       NA
#>      TUEVAL
#> 14     <NA>
#> 22     <NA>
#> 32     <NA>
#> 1      <NA>
#> 2      <NA>
#> 211 Present

# RS domain: response assessment data
rs <- domains$rs
head(rs)
#>    SUBJID      ENRDT  DLCRT           VISIT      RSDAT TRGRESP      NTRGRESP
#> 1 SUBJID1 2026-05-29 300 mg Post-Baseline 1 2026-07-14      SD NON-CR/NON-PD
#> 2 SUBJID1 2026-05-29 300 mg Post-Baseline 2 2026-08-23      SD NON-CR/NON-PD
#> 3 SUBJID1 2026-05-29 300 mg Post-Baseline 3 2026-10-03      SD            PD
#> 4 SUBJID2 2026-02-06 200 mg Post-Baseline 1 2026-03-24      SD NON-CR/NON-PD
#> 5 SUBJID2 2026-02-06 200 mg Post-Baseline 2 2026-05-06      SD NON-CR/NON-PD
#> 6 SUBJID3 2026-08-03 400 mg Post-Baseline 1 2026-09-12      SD NON-CR/NON-PD
#>   NEW OVRLRESP
#> 1   0       SD
#> 2   0       SD
#> 3   1       PD
#> 4   0       SD
#> 5   1       PD
#> 6   0       SD

# AE domain: adverse event data
ae <- domains$ae
head(ae)
#>    SUBJID      ENRDT  DLCRT AETERM       AEREL         AEOUT     AESTDT AEONGO
#> 2 SUBJID1 2026-05-29 300 mg   AE32 Not Related     Recovered 2026-06-03      N
#> 3 SUBJID1 2026-05-29 300 mg   AE93 Not Related Not Recovered 2026-06-06      N
#> 4 SUBJID1 2026-05-29 300 mg    AE1 Not Related Not Recovered 2026-06-08      N
#> 5 SUBJID1 2026-05-29 300 mg   AE73 Not Related     Recovered 2026-06-11      N
#> 6 SUBJID1 2026-05-29 300 mg   AE47     Related     Recovered 2026-06-14      N
#> 7 SUBJID1 2026-05-29 300 mg   AE82     Related     Recovered 2026-06-24      N
#>       AEENDT AETOXGR AESER            AEACN
#> 2 2026-06-07 Grade 1     N Dose Not Changed
#> 3 2026-06-13 Grade 4     N Dose Interrupted
#> 4 2026-06-16 Grade 2     Y     Dose Reduced
#> 5 2026-08-01 Grade 3     N Dose Not Changed
#> 6 2026-06-15 Grade 2     N Dose Not Changed
#> 7 2026-06-28 Grade 1     N     Dose Reduced

# DD domain: death data (returns NULL if no deaths occurred)
dd <- domains$dd
head(dd)
#> NULL

# DS domain: disposition data (returns NULL if no disposition records exist)
ds <- domains$ds
head(ds)
#>    SUBJID      ENRDT  DLCRT            DSCAT             DSDECOD      DSDAT
#> 1 SUBJID1 2026-05-29 300 mg End of Treatment Progressive Disease 2026-10-03
#> 2 SUBJID2 2026-02-06 200 mg End of Treatment       Adverse Event 2026-04-13
#> 3 SUBJID3 2026-08-03 400 mg End of Treatment Progressive Disease 2026-10-27
#> 4 SUBJID5 2026-07-19 200 mg End of Treatment Progressive Disease 2026-10-14

# EX domain: exposure data
ex <- domains$ae
head(ex)
#>    SUBJID      ENRDT  DLCRT AETERM       AEREL         AEOUT     AESTDT AEONGO
#> 2 SUBJID1 2026-05-29 300 mg   AE32 Not Related     Recovered 2026-06-03      N
#> 3 SUBJID1 2026-05-29 300 mg   AE93 Not Related Not Recovered 2026-06-06      N
#> 4 SUBJID1 2026-05-29 300 mg    AE1 Not Related Not Recovered 2026-06-08      N
#> 5 SUBJID1 2026-05-29 300 mg   AE73 Not Related     Recovered 2026-06-11      N
#> 6 SUBJID1 2026-05-29 300 mg   AE47     Related     Recovered 2026-06-14      N
#> 7 SUBJID1 2026-05-29 300 mg   AE82     Related     Recovered 2026-06-24      N
#>       AEENDT AETOXGR AESER            AEACN
#> 2 2026-06-07 Grade 1     N Dose Not Changed
#> 3 2026-06-13 Grade 4     N Dose Interrupted
#> 4 2026-06-16 Grade 2     Y     Dose Reduced
#> 5 2026-08-01 Grade 3     N Dose Not Changed
#> 6 2026-06-15 Grade 2     N Dose Not Changed
#> 7 2026-06-28 Grade 1     N     Dose Reduced
```
