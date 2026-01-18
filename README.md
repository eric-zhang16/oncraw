
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oncraw

<!-- badges: start -->
<!-- badges: end -->

The oncraw package provides an easy-to-use tool for generating raw data
domains (pre-SDTM clinical data) for oncology trials based on Case
Report Forms (CRFs). The simulated data are designed to closely resemble
real-world oncology trial data and can be used by researchers as
training datasets to develop and test AI-enabled workflows for data
processing and TFL automation. The annotated CRFs are stored in the /acrf folder. 

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
#>    SUBJID DSCONT      ENRDT  DLCRT    SEX              ETHNICITY  RACE
#> 1 SUBJID1    Yes 2026-01-08 200 mg   Male Not Hispanic or Latino White
#> 2 SUBJID2     No 2026-03-29 200 mg Female Not Hispanic or Latino White
#> 3 SUBJID3    Yes 2026-09-25 400 mg   Male Not Hispanic or Latino White
#> 4 SUBJID4    Yes 2026-05-20 400 mg Female Not Hispanic or Latino White
#> 5 SUBJID5    Yes 2026-04-13 300 mg Female Not Hispanic or Latino White

# TU domain: tumor evaluation data
tu <- domains$tu
head(tu)
#>      SUBJID      ENRDT  DLCRT     VISIT      TUCAT TULNKID     TULOC      TUDAT
#> 110 SUBJID1 2026-01-08 200 mg Screening Non-Target     NT1  Pancreas 2026-01-10
#> 23  SUBJID1 2026-01-08 200 mg Screening Non-Target     NT2     Ovary 2026-01-10
#> 32  SUBJID1 2026-01-08 200 mg Screening Non-Target     NT3   Bladder 2026-01-10
#> 42  SUBJID1 2026-01-08 200 mg Screening Non-Target     NT4 Esophagus 2026-01-10
#> 52  SUBJID1 2026-01-08 200 mg Screening Non-Target     NT5  Prostate 2026-01-10
#> 1   SUBJID1 2026-01-08 200 mg Screening     Target      T1     Other 2026-01-10
#>                                     TUDIAMI     TUSTAT   TUDIAM TUEVAL
#> 110                                    <NA>       <NA>       NA   <NA>
#> 23                                     <NA>       <NA>       NA   <NA>
#> 32                                     <NA>       <NA>       NA   <NA>
#> 42                                     <NA>       <NA>       NA   <NA>
#> 52                                     <NA>       <NA>       NA   <NA>
#> 1   Longest Diameter for Extranodal Lesions Measurable 55.97206   <NA>

# RS domain: response assessment data
rs <- domains$rs
head(rs)
#>    SUBJID      ENRDT  DLCRT           VISIT      RSDAT TRGRESP      NTRGRESP
#> 1 SUBJID1 2026-01-08 200 mg Post-Baseline 1 2026-02-23      NE NON-CR/NON-PD
#> 2 SUBJID1 2026-01-08 200 mg Post-Baseline 2 2026-04-03      SD NON-CR/NON-PD
#> 3 SUBJID1 2026-01-08 200 mg Post-Baseline 3 2026-05-13      SD NON-CR/NON-PD
#> 4 SUBJID1 2026-01-08 200 mg Post-Baseline 4 2026-06-25      SD NON-CR/NON-PD
#> 5 SUBJID2 2026-03-29 200 mg Post-Baseline 1 2026-05-11      PR NON-CR/NON-PD
#> 6 SUBJID2 2026-03-29 200 mg Post-Baseline 2 2026-06-24      PD NON-CR/NON-PD
#>   NEW OVRLRESP
#> 1   0       NE
#> 2   0       SD
#> 3   0       SD
#> 4   0       SD
#> 5   0       PR
#> 6   0       PD

# AE domain: adverse event data
ae <- domains$ae
head(ae)
#>    SUBJID      ENRDT  DLCRT AETERM       AEREL         AEOUT     AESTDT AEONGO
#> 2 SUBJID1 2026-01-08 200 mg  AE100     Related    Recovering 2026-01-13      Y
#> 3 SUBJID1 2026-01-08 200 mg   AE28     Related Not Recovered 2026-01-14      N
#> 4 SUBJID1 2026-01-08 200 mg   AE20 Not Related     Recovered 2026-01-16      N
#> 5 SUBJID1 2026-01-08 200 mg   AE82 Not Related     Recovered 2026-01-22      N
#> 6 SUBJID1 2026-01-08 200 mg   AE97 Not Related    Recovering 2026-01-25      Y
#> 7 SUBJID1 2026-01-08 200 mg   AE51 Not Related     Recovered 2026-02-11      N
#>       AEENDT AETOXGR AESER            AEACN
#> 2       <NA> Grade 4     N Dose Not Changed
#> 3 2026-01-15 Grade 2     N Dose Not Changed
#> 4 2026-01-24 Grade 3     Y Dose Interrupted
#> 5 2026-01-24 Grade 2     N   Drug Withdrawn
#> 6       <NA> Grade 2     N Dose Not Changed
#> 7 2026-02-21 Grade 2     N Dose Not Changed

# DD domain: death data (returns NULL if no deaths occurred)
dd <- domains$dd
head(dd)
#>    SUBJID      ENRDT  DLCRT     DTHDAT             DTHCAUS
#> 1 SUBJID5 2026-04-13 300 mg 2026-08-20 Disease Progression

# DS domain: disposition data (returns NULL if no disposition records exist)
ds <- domains$ds
head(ds)
#>    SUBJID      ENRDT  DLCRT            DSCAT             DSDECOD      DSDAT
#> 1 SUBJID1 2026-01-08 200 mg End of Treatment       Adverse Event 2026-01-22
#> 2 SUBJID2 2026-03-29 200 mg End of Treatment Progressive Disease 2026-06-24
#> 3 SUBJID3 2026-09-25 400 mg End of Treatment       Adverse Event 2026-10-10
#> 4 SUBJID5 2026-04-13 300 mg End of Treatment Progressive Disease 2026-07-08
#> 5 SUBJID5 2026-04-13 300 mg     End of Study               Death 2026-08-20

# EX domain: exposure data
ex <- domains$ex
head(ex)
#>    SUBJID      ENRDT  DLCRT    EXTRT     EXSTDT EXPDOSE EXADOSE EXADJ
#> 1 SUBJID1 2026-01-08 200 mg New Drug 2026-01-08     200     200     N
#> 2 SUBJID2 2026-03-29 200 mg New Drug 2026-03-29     200     200     N
#> 3 SUBJID2 2026-03-29 200 mg New Drug 2026-04-19     200     200     N
#> 4 SUBJID2 2026-03-29 200 mg New Drug 2026-05-10     200     180     Y
#> 5 SUBJID2 2026-03-29 200 mg New Drug 2026-05-31     200     200     N
#> 6 SUBJID2 2026-03-29 200 mg New Drug 2026-06-21     200     200     N
#>             EXAREAS
#> 1              <NA>
#> 2              <NA>
#> 3              <NA>
#> 4 Dose Interruption
#> 5              <NA>
#> 6              <NA>
```
