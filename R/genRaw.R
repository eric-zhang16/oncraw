#' Title Generate raw data domains for an oncology trial
#'
#' @param N number of patients
#'
#' @return a list of raw data domains.
#' \describe{
#'   \item{dm}{demographics domain}
#'   \item{tu}{tumor assessment domain}
#'   \item{rs}{tumor response domain}
#'   \item{ae}{adverse event domain}
#'   \item{dd}{death detail domain}
#'   \item{ds}{disposition domain}
#'   \item{ex}{exposure domain}
#' }
#' @export
#'
#' @examples
#' # Generate raw oncology domains for 50 patients
#' domains <- genRaw(N=50)
#' dm <- domains$dm
#' tu <- domains$tu
#' rs <- domains$rs
#' ae <- domains$ae
#' dd <- domains$dd
#' ds <- domains$ds
#' ex <- domains$ex
#'
genRaw <- function(N){
  #### (1) dm domain ####

  ## enrollment date, subject ID, dose level ##

  # rep is rep'th subject
  enrollment.fun <- function(rep){
    SUBJID <- paste0('SUBJID',rep,sep='')
    DSCONT <- sample(c("Yes","No"),size=1,prob=c(0.8,0.2))
    ENRDT <- sample(seq.Date(
      from = as.Date("2026-01-01"),
      to   = as.Date("2026-12-01"),
      by   = "day"
    ), size = 1)
    DLCRT <- sample(c("200 mg","300 mg","400 mg"),size=1,prob=c(0.5,0.3,0.2))

    return(data.frame(SUBJID=SUBJID,DSCONT=DSCONT,ENRDT=ENRDT,DLCRT))
  }

  # rep is rep'th subject

  demographic.fun <- function(rep){

    sex.list <- c("Male", "Female")
    sex.p <- c(0.55, 0.45)
    sex <- sample(sex.list, size = 1, prob = sex.p)

    ethnicity.list <- c("Hispanic or Latino", "Not Hispanic or Latino","Not Reported","Unknown")
    ethnicity.p <- c(0.15, 0.8,0.04,0.01)
    ethnicity <- sample(ethnicity.list, size = 1, prob = ethnicity.p)

    race.list <- c("American Indian or Alaska Native", "Asian","Black or African American","Native Hawaiian or Other Pacific Islander","White","Other")
    race.p <- c(0.01, 0.2,0.08,0.01,0.69,0.01)
    race <- sample(race.list, size = 1, prob = race.p)

    return( data.frame(SEX=sex, ETHNICITY=ethnicity,RACE=race ))
  }


  #### (2) tu/rs domain ####

  tumor.fun <- function(dm){

    tuloc.lst <- c('Adrenal Gland','Bladder','Bone','Brain','Breast','Cervix','Esophagus',
                   'Kideny','Larynx','Liver','Lung','Lymph Nodes','Ovary','Pancreas','Prostate','Other')

    ## (1) Screening visit
    # (1.1) target lesion
    n.tar <- sample(seq(1,5),size=1,prob=c(0.2,0.3,0.3,0.1,0.1))
    VISIT <- rep('Screening',n.tar)
    TUCAT <- rep('Target',n.tar)
    TULNKID <- paste0('T',seq(1,n.tar),sep='')
    TUSTAT <- rep('Measurable',n.tar)

    TULOC <- rep(NA,n.tar)
    TUDIAMI <- rep(NA,n.tar)
    TUDIAM <- rep(NA,n.tar)

    # Simulate tumor size at baseline ~ log-normal dist with m=3.4 and sd=0.58
    for(i in 1:n.tar){
      TULOC[i] <- sample(tuloc.lst,size=1)
      if( TULOC[i]=='Lymph Nodes'){
        TUDIAMI[i] <- 'Short Axis for Lymph Nodes'
      } else {
        TUDIAMI[i] <- 'Longest Diameter for Extranodal Lesions'
      }
      TUDIAM[i] <- exp(max(rnorm(1,mean=3.4,sd=0.58),log(15)) )

    }

    TUDAT <- rep( (dm$ENRDT + sample(1:3,size=1)),n.tar)

    tutr.tar.screen <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,VISIT,TUCAT,TULNKID,TULOC,TUDAT,TUDIAMI,TUSTAT, TUDIAM,TUEVAL=NA)

    # (1.2) non-target lesion
    n.ntar <- sample(seq(1,5),size=1,prob=c(0.2,0.3,0.3,0.1,0.1))
    TUCAT <- rep('Non-Target',n.ntar)
    VISIT <- rep('Screening',n.ntar)
    TULNKID <- paste0('NT',seq(1,n.ntar),sep='')
    TUDAT <- rep(TUDAT[1],n.ntar)
    TULOC <- rep(NA,n.ntar)
    for(i in 1:n.ntar){
      TULOC[i] <- sample(tuloc.lst,size=1)
    }

    tutr.ntar.screen <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,VISIT,TUCAT,TULNKID,TULOC,TUDAT,TUDIAMI=NA,TUSTAT=NA,TUDIAM=NA,TUEVAL=NA)

    ## (2) Post-baseline visit
    # (2.1) target lesion
    n.scan <- sample(seq(1,6),size=1,prob=c(0.1,0.2,0.3,0.2,0.1,0.1))

    # Model the change in tumor size as
    #       %CHG = beta0 + beta1*scan1 (0 vs 1) +...+ beta7*scan7 (0 vs 1) + error
    #              beta0=-23%, beta1=-15%, beta3=-16%, beta4=-19%, beta5=-25%, bet6=-25%, beta7=-20%
    #              error ~ normal (0, 14%)
    pch.tumor <- function(scan){
      pchg <- -0.23*(scan==1)-0.15*(scan==2)-0.16*(scan==3)-0.19*(scan==4)-0.25*(scan==5)-0.25*(scan==6)-0.20*(scan==7) +rnorm(1,0,0.14)
      pchg <- max(-1,pchg )
      return(pchg)
    }

    tutr.tar.post <- data.frame(SUBJID=NA,ENRDT=as.Date(NA),DLCRT=NA,VISIT=NA,TUCAT=NA,TULNKID=NA,TULOC=NA,TUDAT=as.Date(NA),TUDIAMI=NA,TUSTAT=NA,TUDIAM=NA,TUEVAL=NA)
    for(j in 1:n.scan){
      VISIT <- rep(paste0('Post-Baseline ',j,sep=''),n.tar)
      TUCAT <- tutr.tar.screen$TUCAT
      TULNKID <- tutr.tar.screen$TULNKID
      TULOC <- tutr.tar.screen$TULOC
      TUDIAMI <- tutr.tar.screen$TUDIAMI
      TUDAT <- tutr.tar.screen$TUDAT + 6*7*j + sample(-3:3,size=1)
      TUDIAM <- rep(NA,n.tar)
      TUSTAT <- rep(NA,n.tar)
      for(jj in 1:n.tar){
        measure.yes <- sample(c(0,1),size=1,prob=c(0.01,0.99))
        if(measure.yes ==1 ){
          TUSTAT[jj] <- 'Measurable'
          TUDIAM [jj] <- (1+pch.tumor(scan=j))*tutr.tar.screen$TUDIAM[jj]
        } else {
          TUSTAT[jj] <- 'Not Evaluable'
          TUDIAM [jj] <- NA
        }
      }
      tutr.tar.post.tmp <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,VISIT,TUCAT,TULNKID,TULOC,TUDAT,TUDIAMI,TUSTAT, TUDIAM,TUEVAL=NA)
      tutr.tar.post <- rbind(tutr.tar.post,tutr.tar.post.tmp)
    }
    tutr.tar.post <- tutr.tar.post[-1,]
    tutr.tar <- rbind(tutr.tar.screen,tutr.tar.post)

    # (2.2) non-target lesion
    tutr.ntar.post <- data.frame(SUBJID=NA,ENRDT=as.Date(NA),DLCRT=NA,VISIT=NA,TUCAT=NA,TULNKID=NA,TULOC=NA,TUDAT=as.Date(NA),TUDIAMI=NA,TUSTAT=NA,TUDIAM=NA,TUEVAL=NA)
    for(j in 1:n.scan){
      VISIT <- rep(paste0('Post-Baseline ',j,sep=''),n.ntar)
      TUCAT <- tutr.ntar.screen$TUCAT
      TULNKID <- tutr.ntar.screen$TULNKID
      TULOC <- tutr.ntar.screen$TULOC
      TUDAT <- unique(tutr.tar.post$TUDAT)[j]
      TUEVAL <- rep(NA,n.ntar)
      pd.stat <- 0
      for(l in 1:n.ntar){
        if(pd.stat==0){
          TUEVAL[l] <- sample(c('Present','Absent','Unequivocal Progression'),size=1, prob=c(0.8,0.19,0.01))
          if(TUEVAL[l]== 'Unequivocal Progression'){
            pd.stat <- 1
          }
        } else {
          TUEVAL[l] <- 'Unequivocal Progression'
        }

      }

      tutr.ntar.post.tmp <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,VISIT,TUCAT,TULNKID,TULOC,TUDAT,TUDIAMI=NA,TUSTAT=NA,TUDIAM=NA,TUEVAL)
      tutr.ntar.post <- rbind(tutr.ntar.post,tutr.ntar.post.tmp)
    }

    tutr.ntar.post <- tutr.ntar.post[-1,]
    tutr.ntar <- rbind(tutr.ntar.screen,tutr.ntar.post)

    ## (3) New Lesion
    tutr.new <- data.frame(SUBJID=NA,ENRDT=as.Date(NA),DLCRT=NA,VISIT=NA,TUCAT=NA,TULNKID=NA,TULOC=NA,TUDAT=as.Date(NA),TUDIAMI=NA,TUSTAT=NA,TUDIAM=NA,TUEVAL=NA)
    n.new.cum <- 0

    for(j in 1:n.scan){
      new.yes <- sample(c(0,1),size=1,prob=c(0.85,0.15) )
      if(new.yes==1){
        n.new <- sample(seq(1,3),size=1,prob=c(0.8,0.15,0.05))
        n.new.cum <- n.new.cum + n.new
        VISIT <- rep(paste0('Post-Baseline ',j,sep=''),n.new)
        TUCAT <- rep("New Lesion",n.new)
        TUSTAT <- rep('Measurable',n.new)
        TULNKID <- paste0('NEW',seq( (n.new.cum-n.new+1),n.new.cum),sep='')
        TUDAT <- unique(tutr.tar.post$TUDAT)[j]

        TULOC <- rep(NA,n.new)
        TUDIAMI <- rep(NA,n.new)
        TUDIAM <- rep(NA,n.new)

        # Simulate tumor size at baseline ~ log-normal dist with m=2.9 and sd=0.5
        for(i in 1:n.new){
          TULOC[i] <- sample(tuloc.lst,size=1)
          if( TULOC[i]=='Lymph Nodes'){
            TUDIAMI[i] <- 'Short Axis for Lymph Nodes'
          } else {
            TUDIAMI[i] <- 'Longest Diameter for Extranodal Lesions'
          }
          TUDIAM[i] <- exp(max(rnorm(1,mean=2.9,sd=0.5),log(15)) )
        }

        tutr.new.tmp <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,VISIT,TUCAT,TULNKID,TULOC,TUDAT,TUDIAMI,TUSTAT,TUDIAM,TUEVAL=NA)
        tutr.new <- rbind(tutr.new,tutr.new.tmp)
      }

    }
    if(nrow(tutr.new)>=2){
      tutr.new <- tutr.new [-1,]
      new.yes <- 1
    } else {
      new.yes <- 0
    }


    ## (4) Combined tumor lesion dataset (target + non-target) for response assessment
    if(new.yes==1){
      tutr.lesion <- rbind(tutr.tar,tutr.ntar,tutr.new)
    } else {
      tutr.lesion <- rbind(tutr.tar,tutr.ntar)
    }

    tutr.lesion <- tutr.lesion[order(tutr.lesion$TUDAT, tutr.lesion$TUCAT), ]

    u.date <- unique(subset(tutr.lesion,VISIT!='Screening')$TUDAT)
    u.visit<- unique(subset(tutr.lesion,VISIT!='Screening')$VISIT)
    u.date <- u.date[order(u.date)]

    tar.screen.sum <- sum(subset(tutr.lesion,VISIT=='Screening' & TUCAT=='Target'  )$TUDIAM)
    lymph.yes <- 1*(nrow(subset(tutr.lesion,VISIT=='Screening' & TUCAT=='Target' & TULOC=='Lymph Nodes' ))>0)
    tar.screen.nonlymph.sum <- sum(subset(tutr.lesion,VISIT=='Screening' & TUCAT=='Target' & TULOC!='Lymph Nodes' )$TUDIAM)
    if(lymph.yes==1){
      tar.sum.lst <- c(tar.screen.nonlymph.sum)
    } else {
      tar.sum.lst <- c(tar.screen.sum)
    }

    TRGRESP <- rep(NA,length(u.date ))
    NTRGRESP <- rep(NA,length(u.date ))
    OVRLRESP <- rep(NA,length(u.date ))
    newlesion <- rep(NA,length(u.date ))
    RSDAT <- u.date

    for(i in 1:length(u.date )){
      tutr.lesion.tmp <- subset(tutr.lesion,TUDAT==u.date[i])

      # Target lesion response #
      tutr.lesion.tar.tmp <- subset(tutr.lesion.tmp,TUCAT=='Target')

      if(sum(tutr.lesion.tar.tmp$TUSTAT=='Not Evaluable')>0 ){  #check if any not evaluate
        TRGRESP[i] <- 'NE'
      } else {
        tar.curr.sum <- sum(tutr.lesion.tar.tmp$TUDIAM)
        pch2screen.tar <- tar.curr.sum/tar.screen.sum
        if(i==1){
          pch4pd.tar <- pch2screen.tar
        } else {
          tar.min.sum <- min(tar.sum.lst)
          pch4pd.tar <- tar.curr.sum/tar.min.sum
        }
        tar.sum.lst <- c(tar.sum.lst,tar.curr.sum)

        if(lymph.yes==1){
          tutr.lesion.tar.lymnd <- subset(tutr.lesion.tar.tmp,TULOC=='Lymph Nodes')
          n.lymnd <- nrow(tutr.lesion.tar.lymnd)
          lymnd.CR <- 1
          for(x in 1:n.lymnd){
            if(tutr.lesion.tar.lymnd$TUDIAM[x]>10){
              lymnd.CR <- 0
            }
          }

          if(pch2screen.tar==0 & lymnd.CR==1  ){
            TRGRESP[i] <- 'CR'
          } else if(pch4pd.tar>1.2){
            TRGRESP[i] <- 'PD'
          } else if(pch2screen.tar<0.7){
            TRGRESP[i] <- 'PR'
          } else {
            TRGRESP[i] <- 'SD'
          }
        } else {
          if( pch2screen.tar==0 ){
            TRGRESP[i] <- 'CR'
          } else if(pch4pd.tar>1.2){
            TRGRESP[i] <- 'PD'
          } else if(pch2screen.tar<0.7){
            TRGRESP[i] <- 'PR'
          } else {
            TRGRESP[i] <- 'SD'
          }
        }
      }

      # Non-Target lesion response #
      tutr.lesion.ntar.tmp <- subset(tutr.lesion.tmp,TUCAT=='Non-Target')

      if(sum(tutr.lesion.ntar.tmp$TUEVAL %in% c('Present','Unequivocal Progression') )==0){
        NTRGRESP[i] <- 'CR'
      } else if(  sum(tutr.lesion.ntar.tmp$TUEVAL=='Unequivocal Progression') > 0 ){
        NTRGRESP[i] <- 'PD'
      } else {
        NTRGRESP[i] <- 'NON-CR/NON-PD'
      }

      # New Lesion
      tutr.lesion.new.tmp <- subset(tutr.lesion.tmp,TUCAT=='New Lesion')
      newlesion[i] <- 1*(nrow(tutr.lesion.new.tmp)>0)
      # Overall Response #
      if(TRGRESP[i]=='PD' | NTRGRESP[i]=='PD' | newlesion[i]==1){
        OVRLRESP[i] <- 'PD'
      } else if(TRGRESP[i]=='NE' & NTRGRESP[i]!='PD' & newlesion[i]==0) {
        OVRLRESP[i] <- 'NE'
      } else if(TRGRESP[i]=='CR' & NTRGRESP[i]=='CR' & newlesion[i]==0 ){
        OVRLRESP[i] <- 'CR'
      } else if(TRGRESP[i]=='CR' & NTRGRESP[i]=='NON-CR/NON-PD' & newlesion[i]==0){
        OVRLRESP[i] <- 'PR'
      } else if(TRGRESP[i]=='PR' & NTRGRESP[i] %in% c('CR','NON-CR/NON-PD') & newlesion[i]==0){
        OVRLRESP[i] <- 'PR'
      } else if(TRGRESP[i]=='SD' & NTRGRESP[i] %in% c('CR','NON-CR/NON-PD') & newlesion[i]==0){
        OVRLRESP[i] <- 'SD'
      }

    }

    rs.all <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,VISIT=u.visit,RSDAT, TRGRESP,NTRGRESP,NEW=newlesion,OVRLRESP)
    pd.1stid <- which(OVRLRESP == "PD")[1]

    # Update tu and rs domains to remove observations after overall response of PD
    if(is.na(pd.1stid)){
      tu <- tutr.lesion
      rs <- rs.all
    } else {
      tu <- subset(tutr.lesion, TUDAT<=RSDAT[pd.1stid])
      rs <- subset(rs.all, RSDAT<=RSDAT[pd.1stid])
    }


    return(list(tu=tu, rs=rs))
  }


  #### (3) ae domain ####

  ae.fun <- function(dm,rs){

    enrdt <- dm$ENRDT
    n.scan <- nrow(rs)
    rs.maxdate <- max(rs$RSDAT, na.rm=T) # fatal AE can only occur after max rs$RSDAT
    if(rs$OVRLRESP[n.scan]=='PD'){
      ae.period <- n.scan*6*7
    } else {
      ae.period <- (n.scan+1)*6*7-7
    }

    ae.possible.dates <- seq.Date(from = enrdt ,
                                  to   = enrdt + ae.period,
                                  by   = "day")

    ae.list <- paste0("AE", 1:100)

    ae <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,AETERM=NA,AEREL=NA,AEOUT=NA,AESTDT=as.Date(NA),AEONGO=NA,AEENDT=as.Date(NA),AETOXGR=NA,AESER=NA,AEACN=NA)
    ae2dc.yes <- 0
    i <- 1
    ae.days <- length(ae.possible.dates)
    while(i <= ae.days ) {
      ae.yes <- sample(c(0,1),size=1,prob=c(0.85,0.15))
      if(ae.yes==1){
        AESTDT <- ae.possible.dates[i]
        AETERM  <- sample( ae.list ,size=1  )
        AEREL <- sample(  c("Related","Not Related"),size=1,prob=c(0.3,0.7) )
        AETOXGR <- sample(c("Grade 1","Grade 2","Grade 3","Grade 4","Grade 5"), size=1, prob=c(0.3,0.3,0.24,0.15,0.01))
        AESER <- sample( c('Y','N'),size=1,  prob=c(0.2,0.8)  )
        if(ae2dc.yes==0){
          AEACN <- sample(  c('Dose Not Changed', 'Dose Interrupted', 'Dose Reduced', 'Drug Withdrawn'), size=1, prob=c(0.9395,0.05,0.01,0.0005)   )
        } else {
          AEACN <- sample(  c('Dose Not Changed', 'Dose Interrupted', 'Dose Reduced'), size=1, prob=c(0.94,0.05,0.01)   )
        }

        AEONGO <- sample(c('N','Y'),size=1,prob=c(0.7,0.3))
        if(AEONGO=='N'){
          AEENDT <- AESTDT + ceiling(exp(rnorm(1,mean=1.94,sd=1.4)))
          if(!is.na(rs.maxdate)){
            if(AESTDT>rs.maxdate){
              AEOUT <- sample(c('Recovered','Not Recovered','Fatal'),size=1,prob=c(0.65,0.28,0.07))
            } else {
              AEOUT <- sample(c('Recovered','Not Recovered'),size=1,prob=c(0.65,0.35))
            }
          } else {
            AEOUT <- sample(c('Recovered','Not Recovered','Fatal'),size=1,prob=c(0.65,0.28,0.07))
          }


        } else {
          AEENDT <- NA
          AEOUT <- sample(c('Recovering','Not Recovered'),size=1,prob=c(0.6,0.4))
        }

        if(AEOUT=='Fatal'){
          AETOXGR <- 'Grade 5'
          AESER <- 'Y'
          AEENDT <- AESTDT + ceiling(exp(rnorm(1,mean=1.94,sd=1.4)))
          AEONGO <- 'N'
          if(is.na(rs.maxdate)){
            AEACN <- 'Drug Withdrawn'
          }
        }


        ae.tmp <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,AETERM,AEREL,AEOUT,AESTDT,AEONGO,AEENDT,AETOXGR,AESER,AEACN)
        ae <- rbind(ae,ae.tmp)


        if(AEACN=='Drug Withdrawn'){
          ae.days <- i + min(30, (ae.days-i))
          ae2dc.yes <- 1
        }

        if(AEOUT=='Fatal'){
          break
        }

      }
      i <- i+1

    }
    ae  <- ae[-1,]


    return(ae)

  }


  #### (4) dth domain (death) ####
  # AE lead to d/c < PD < fatal AE < death (not fatal AE)

  dth.fun <- function(dm,rs,ae){
    fatal.ae.date <- subset(ae,AEOUT=='Fatal')$AEENDT[1]
    pd.date <- subset(rs,OVRLRESP=='PD')$RSDAT[1]
    enroll.date <- dm$ENRDT
    dth.yes <- 0
    if(!is.na(fatal.ae.date)){
      dth.yes <- 1
      DTHDAT <- fatal.ae.date
      DTHCAUS <- 'Adverse Event'
    } else if(!is.na(pd.date )){
      dth.yes <- sample(c(0,1),size=1,prob=c(0.7,0.3))
      if(dth.yes==1){
        DTHDAT <- pd.date + sample(seq(30,90),size=1)
        DTHCAUS <- 'Disease Progression'
      }
    } else {
      dth.yes <- sample(c(0,1),size=1,prob=c(0.95,0.05))
      if(dth.yes==1){
        start.dth <- max(max(rs$RSDAT),max(ae$AEENDT,na.rm=TRUE),na.rm=T)
        DTHDAT <- start.dth + sample(seq(30,90),size=1)
        DTHCAUS <- sample(c('Unknown','Other'),size=1)
      }
    }

    if(dth.yes == 1){
      dd <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,DTHDAT,DTHCAUS)
    } else {
      dd <- c()
    }

    return(dd)
  }

  #### (5) ds domain (EOT and EOS) ####

  ds.fun <- function(dm,rs,ae,dd){
    enrol.date <- dm$ENRDT[1]
    pd.date <- subset(rs,OVRLRESP=='PD')$RSDAT[1]
    rs.maxdur <- as.Date(max(rs$RSDAT,na.rm=T)) - enrol.date + 1
    fatal.ae.date <- subset(ae,AEOUT=='Fatal')$AEENDT[1]
    ae2dc.date <- subset(ae,AEACN=='Drug Withdrawn')$AESTDT[1]
    if(is.null(dd)){
      dth.date <- NA
    } else {
      dth.date <- dd$DTHDAT[1]
    }


    # EOT #
    eot.yes <-  0
    if(!is.na(ae2dc.date)){
      eot.yes <- 1
      DSCAT <- 'End of Treatment'
      DSDECOD <- 'Adverse Event'
      DSDAT <- ae2dc.date
    } else if(!is.na(pd.date)){
      eot.yes <- 1
      DSCAT <- 'End of Treatment'
      DSDECOD <- 'Progressive Disease'
      DSDAT <- pd.date
    } else if(!is.na(dth.date)){  # non-fatal AE death
      eot.yes <- 1
      DSCAT <- 'End of Treatment'
      DSDECOD <- 'Death'
      DSDAT <- dth.date
    } else if(  !is.na(rs.maxdur) & rs.maxdur > 365){
      eot.yes <- 1
      DSCAT <- 'End of Treatment'
      DSDECOD <- 'Completed'
      DSDAT <- max(rs$RSDAT,na.rm=T) +7
    } else {
      eot.yes <- sample(c(0,1),size=1,prob=c(0.8,0.2))
      if(eot.yes==1){
        DSCAT <- 'End of Treatment'
        DSDECOD <- sample(c('Lost To Follow-up','Physician Decision','Withdrawal by Subject','Protocol Deviation'),size=1)
        start.eot <- max(max(rs$RSDAT),max(ae$AEENDT,na.rm=TRUE),na.rm=T)
        DSDAT <- start.eot + sample(seq(1,21),size=1)
      }
    }

    if(eot.yes == 1){
      ds.eot <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,DSCAT,DSDECOD,DSDAT)
    } else {
      ds.eot <- c()
    }

    # EOS #
    eos.yes <-  0
    if(!is.na(fatal.ae.date) | !is.na(dth.date)){
      eos.yes <- 1
      DSCAT <- 'End of Study'
      DSDECOD <-  'Death'
      DSDAT <- max(fatal.ae.date,dth.date,na.rm=T)
    } else if(eot.yes==1){
      if(ds.eot$DSDECOD=='Lost To Follow-up'){
        eos.yes <- 1
        DSCAT <- 'End of Study'
        DSDECOD <-  'Lost To Follow-up'
        DSDAT <- ds.eot$DSDAT
      }
    }

    if(eos.yes == 1){
      ds.eos <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,DSCAT,DSDECOD,DSDAT)
    } else {
      ds.eos <- c()
    }

    ds <- rbind(ds.eot,ds.eos)
  }

  #### (6) ex domain (exposure) ####
  # AE lead to d/c < PD < fatal AE < death (not fatal AE)

  ex.fun <- function(dm,rs,ae,dd,ds){

    enrol.date <- dm$ENRDT[1]
    if(!is.null(ds)){
      eot.date <- subset(ds,DSCAT=='End of Treatment')$DSDAT[1]
    } else {
      eot.date <- NA
    }

    if(!is.na(eot.date)){
      ds.date <- eot.date
    }  else {
      if(is.null(rs)){
        rs.maxdate <- as.Date(NA)
      } else {
        rs.maxdate <- max(rs$RSDAT,na.rm=T)
      }
      if(is.null(ae)){
        ae.maxdate <- as.Date(NA)
      } else {
        ae.maxdate <- max(ae$AESTDT,na.rm=T)
      }
      if(is.na(rs.maxdate) & is.na(ae.maxdate)){
        end.exp.start <- enrol.date
      } else {
        end.exp.start <- max(rs.maxdate,ae.maxdate,na.rm=TRUE)
      }
      ds.date <- end.exp.start + sample(  seq(1,21),size=1  )
    }

    n.cycle <- ceiling((ds.date - enrol.date + 1)/21)
    EXTRT <- 'New Drug'

    ex <- c()
    dose.reduce <- 0
    for(i in 1:n.cycle){
      VISIT <- paste0('Cycle ',n.cycle,sep='')
      EXSTDT <- enrol.date + (i-1)*21
      EXPDOSE <- 200*(1-0.25*dose.reduce)
      EXADJ <- sample(c('Y','N'),size=1,prob=c(0.2,0.8))
      if(EXADJ=='Y'){
        if(dose.reduce <1){
          EXAREAS <- sample(c('Dose Interruption','Dose Reduced'),size=1, prob=c(0.8,0.2))
        } else {
          EXAREAS <- 'Dose Reduced'
        }
        if(EXAREAS=='Dose Interruption'){
          EXADOSE <- EXPDOSE*sample(c(0.9,0.8,0.7,0.6,0.5),size=1,prob=c(0.3,0.3,0.15,0.15,0.1))
        } else {
          dose.reduce <- dose.reduce + 1
          EXADOSE <- EXPDOSE
        }
      } else {
        EXAREAS <- NA
        EXADOSE <- EXPDOSE
      }

      ex.tmp <- data.frame(SUBJID=dm$SUBJID,ENRDT=dm$ENRDT,DLCRT=dm$DLCRT,EXTRT,VISIT,EXSTDT,EXPDOSE,EXADOSE,EXADJ,EXAREAS)
      ex <- rbind(ex,ex.tmp)
    }
    return(ex)
  }

  dm.all <- c()
  tu.all <- c()
  rs.all <- c()
  ae.all <- c()
  dd.all <- c()
  ds.all <- c()
  ex.all <- c()
  for(rep in 1:N){
    dm.enroll <- enrollment.fun(  paste0(rep) )
    dm.demo <- demographic.fun(paste0(rep))
    dm <- cbind(dm.enroll,dm.demo)
    turs <- tumor.fun(dm)
    tu <- turs[[1]]
    rs <- turs[[2]]
    ae <- ae.fun(dm,rs)
    dd <- dth.fun(dm,rs,ae)
    ds<- ds.fun(dm,rs,ae,dd)
    ex <- ex.fun(dm,rs,ae,dd,ds)

    dm.all <- rbind(dm.all,dm)
    tu.all <- rbind(tu.all,tu)
    rs.all <- rbind(rs.all,rs)
    ae.all <- rbind(ae.all,ae)
    dd.all <- rbind(dd.all,dd)
    ds.all <- rbind(ds.all,ds)
    ex.all <- rbind(ex.all,ex)
  }

  res <- list(dm=dm.all,tu=tu.all,rs=rs.all,ae=ae.all,dd=dd.all,ds=ds.all,ex=ex.all)
  return(res)
}




