'
BIOSTATISTICS II 2020 - MIDTERM ASSIGNMENT
By: Vinyas Harish, MD/PhD student year 3, University of Toronto
Last Modified:  May 7 2020

Dataset Description: Dataset of 560k patient visits in three Yale ERs.
Dataset Source: https://github.com/yaleemmlc/admissionprediction (Github, can download the dataframe), 
https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0201016#pone.0201016.ref012(accompanying PLoS ONE paper)
'
library(plyr) 
load("~/Desktop/Data Science /Yale EM Dataset/yaleEM.RData")

#This dataset is too large to hold in SAS and unfortunately they are not in the order that the data dict suggests 

'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OUTCOME 1:  PREDICTING ADMISSION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'
#Using demographics and triage information to predict disposition (without Chief Complaint) ####
dispositionPrediction_noCC = subset(df, select = c( 
                                disposition,
                                age,
                                gender,
                                ethnicity,
                                race,
                                lang,
                                religion,
                                maritalstatus,
                                employstatus,
                                insurance_status,
                                dep_name,
                                arrivalmode,
                                arrivalmonth,
                                arrivalday,
                                arrivalhour_bin,
                                triage_vital_hr,
                                triage_vital_sbp,
                                triage_vital_dbp,
                                triage_vital_rr,
                                triage_vital_o2,
                                triage_vital_o2_device,
                                triage_vital_temp,
                                esi,
                                previousdispo,
                                n_edvisits,
                                n_admissions,
                                n_surgeries)) 

#Apprend Chief Complaints
ccdf = df[ , grepl( "cc_" , names( df ) ) ]
dispositionPrediction_wCC = cbind(dispositionPrediction_noCC, ccdf)

#Reduce the number of columns of chief complaint based on RoS ####
dispositionPrediction_wCC$cc_const <- dispositionPrediction_wCC$cc_chills + 
                                      dispositionPrediction_wCC$cc_fatigue +
                                      dispositionPrediction_wCC$cc_fever +
                                      dispositionPrediction_wCC$`cc_fever-75yearsorolder` +
                                      dispositionPrediction_wCC$`cc_fever-9weeksto74years` +
                                      dispositionPrediction_wCC$cc_feverimmunocompromised +
                                      dispositionPrediction_wCC$cc_generalizedbodyaches +
                                      dispositionPrediction_wCC$cc_lethargy +
                                      dispositionPrediction_wCC$cc_lossofconsciousness +
                                      dispositionPrediction_wCC$cc_mass +
                                      dispositionPrediction_wCC$cc_pain +
                                      dispositionPrediction_wCC$cc_unresponsive +
                                      dispositionPrediction_wCC$cc_weakness

dispositionPrediction_wCC$cc_heent <- dispositionPrediction_wCC$cc_blurredvision + 
                                      dispositionPrediction_wCC$cc_conjunctivitis + 
                                      dispositionPrediction_wCC$cc_dentalpain +
                                      dispositionPrediction_wCC$cc_dizziness +
                                      dispositionPrediction_wCC$cc_earpain +
                                      dispositionPrediction_wCC$cc_earproblem +
                                      dispositionPrediction_wCC$cc_epistaxis +
                                      dispositionPrediction_wCC$cc_eyepain +
                                      dispositionPrediction_wCC$cc_eyeproblem +
                                      dispositionPrediction_wCC$cc_eyeredness +
                                      dispositionPrediction_wCC$cc_facialpain +
                                      dispositionPrediction_wCC$cc_facialswelling +
                                      dispositionPrediction_wCC$cc_foreignbodyineye +
                                      dispositionPrediction_wCC$cc_headache +
                                      dispositionPrediction_wCC$`cc_headache-newonsetornewsymptoms` +
                                      dispositionPrediction_wCC$`cc_headache-recurrentorknowndxmigraines` +
                                      dispositionPrediction_wCC$`cc_headachere-evaluation` +
                                      dispositionPrediction_wCC$cc_jawpain +
                                      dispositionPrediction_wCC$cc_migraine +
                                      dispositionPrediction_wCC$cc_nasalcongestion +
                                      dispositionPrediction_wCC$cc_neckpain +
                                      dispositionPrediction_wCC$cc_oralswelling +
                                      dispositionPrediction_wCC$cc_otalgia +
                                      dispositionPrediction_wCC$cc_sinusproblem +
                                      dispositionPrediction_wCC$cc_sorethroat

dispositionPrediction_wCC$cc_cardiovasc <- dispositionPrediction_wCC$cc_cardiacarrest + 
                                           dispositionPrediction_wCC$cc_chestpain + 
                                           dispositionPrediction_wCC$cc_chesttightness + 
                                           dispositionPrediction_wCC$cc_hypertension + 
                                           dispositionPrediction_wCC$cc_hypotension + 
                                           dispositionPrediction_wCC$cc_irregularheartbeat + 
                                           dispositionPrediction_wCC$cc_nearsyncope + 
                                           dispositionPrediction_wCC$cc_palpitations + 
                                           dispositionPrediction_wCC$cc_rapidheartrate + 
                                           dispositionPrediction_wCC$cc_syncope +
                                           dispositionPrediction_wCC$cc_tachycardia

dispositionPrediction_wCC$cc_resp <- dispositionPrediction_wCC$cc_asthma + 
                                     dispositionPrediction_wCC$cc_breathingdifficulty + 
                                     dispositionPrediction_wCC$cc_breathingproblem + 
                                     dispositionPrediction_wCC$cc_coldlikesymptoms + 
                                     dispositionPrediction_wCC$cc_cough + 
                                     dispositionPrediction_wCC$cc_dyspnea + 
                                     dispositionPrediction_wCC$cc_hemoptysis + 
                                     dispositionPrediction_wCC$cc_influenza + 
                                     dispositionPrediction_wCC$cc_respiratorydistress + 
                                     dispositionPrediction_wCC$cc_shortnessofbreath +
                                     dispositionPrediction_wCC$cc_wheezing +
                                     dispositionPrediction_wCC$cc_uri

dispositionPrediction_wCC$cc_gi <- dispositionPrediction_wCC$cc_abdominalcramping +
                                   dispositionPrediction_wCC$cc_abdominaldistention +
                                   dispositionPrediction_wCC$cc_abdominalpain +
                                   dispositionPrediction_wCC$cc_abdominalpainpregnant +
                                   dispositionPrediction_wCC$cc_constipation +
                                   dispositionPrediction_wCC$cc_diarrhea +
                                   dispositionPrediction_wCC$cc_emesis +
                                   dispositionPrediction_wCC$cc_epigastricpain +
                                   dispositionPrediction_wCC$cc_gibleeding +
                                   dispositionPrediction_wCC$cc_giproblem +
                                   dispositionPrediction_wCC$cc_ingestion +
                                   dispositionPrediction_wCC$cc_nausea +
                                   dispositionPrediction_wCC$cc_rectalbleeding +
                                   dispositionPrediction_wCC$cc_rectalpain +
                                   dispositionPrediction_wCC$cc_swallowedforeignbody

dispositionPrediction_wCC$cc_gu <- dispositionPrediction_wCC$cc_dysuria +
                                   dispositionPrediction_wCC$cc_exposuretostd +
                                   dispositionPrediction_wCC$cc_femaleguproblem +
                                   dispositionPrediction_wCC$cc_flankpain +
                                   dispositionPrediction_wCC$cc_groinpain +
                                   dispositionPrediction_wCC$cc_hematuria +
                                   dispositionPrediction_wCC$cc_maleguproblem +
                                   dispositionPrediction_wCC$cc_pelvicpain +
                                   dispositionPrediction_wCC$cc_stdcheck +
                                   dispositionPrediction_wCC$cc_testiclepain +
                                   dispositionPrediction_wCC$cc_urinaryfrequency +
                                   dispositionPrediction_wCC$cc_urinaryretention +
                                   dispositionPrediction_wCC$cc_urinarytractinfection +
                                   dispositionPrediction_wCC$cc_vaginalbleeding +
                                   dispositionPrediction_wCC$cc_vaginaldischarge + 
                                   dispositionPrediction_wCC$cc_vaginalpain

dispositionPrediction_wCC$cc_msk <- dispositionPrediction_wCC$cc_anklepain +
                                    dispositionPrediction_wCC$cc_armpain +
                                    dispositionPrediction_wCC$cc_armswelling +
                                    dispositionPrediction_wCC$cc_backpain +
                                    dispositionPrediction_wCC$cc_elbowpain +
                                    dispositionPrediction_wCC$cc_fingerpain +
                                    dispositionPrediction_wCC$cc_fingerswelling +
                                    dispositionPrediction_wCC$cc_footpain +
                                    dispositionPrediction_wCC$cc_footswelling +
                                    dispositionPrediction_wCC$cc_handpain +
                                    dispositionPrediction_wCC$cc_hippain +
                                    dispositionPrediction_wCC$cc_jointswelling +
                                    dispositionPrediction_wCC$cc_kneepain +
                                    dispositionPrediction_wCC$cc_legpain +
                                    dispositionPrediction_wCC$cc_legswelling +
                                    dispositionPrediction_wCC$cc_ribpain +
                                    dispositionPrediction_wCC$cc_shoulderpain +
                                    dispositionPrediction_wCC$cc_toepain +
                                    dispositionPrediction_wCC$cc_wristpain

dispositionPrediction_wCC$cc_derm <- dispositionPrediction_wCC$cc_breastpain +
                                     dispositionPrediction_wCC$cc_cellulitis +
                                     dispositionPrediction_wCC$cc_abscess +
                                     dispositionPrediction_wCC$cc_cyst +
                                     dispositionPrediction_wCC$`cc_follow-upcellulitis` +
                                     dispositionPrediction_wCC$cc_rash +
                                     dispositionPrediction_wCC$cc_skinirritation +
                                     dispositionPrediction_wCC$cc_skinproblem +
                                     dispositionPrediction_wCC$cc_woundcheck +
                                     dispositionPrediction_wCC$cc_woundinfection +
                                     dispositionPrediction_wCC$`cc_woundre-evaluation`

dispositionPrediction_wCC$cc_neuro <- dispositionPrediction_wCC$cc_confusion +
                                      dispositionPrediction_wCC$cc_extremityweakness +
                                      dispositionPrediction_wCC$cc_neurologicproblem +
                                      dispositionPrediction_wCC$cc_numbness +
                                      dispositionPrediction_wCC$`cc_seizure-newonset`+
                                      dispositionPrediction_wCC$`cc_seizure-priorhxof` +
                                      dispositionPrediction_wCC$cc_seizures +
                                      dispositionPrediction_wCC$cc_strokealert

dispositionPrediction_wCC$cc_psych <- dispositionPrediction_wCC$cc_addictionproblem +
                                      dispositionPrediction_wCC$cc_agitation +
                                      dispositionPrediction_wCC$cc_alteredmentalstatus +
                                      dispositionPrediction_wCC$cc_alcoholintoxication +
                                      dispositionPrediction_wCC$cc_alcoholproblem +
                                      dispositionPrediction_wCC$cc_anxiety +
                                      dispositionPrediction_wCC$cc_depression +
                                      dispositionPrediction_wCC$cc_detoxevaluation +
                                      dispositionPrediction_wCC$`cc_drug/alcoholassessment` +
                                      dispositionPrediction_wCC$cc_hallucinations +
                                      dispositionPrediction_wCC$cc_homicidal +
                                      dispositionPrediction_wCC$cc_panicattack +
                                      dispositionPrediction_wCC$cc_psychiatricevaluation +
                                      dispositionPrediction_wCC$cc_psychoticsymptoms +
                                      dispositionPrediction_wCC$cc_suicidal +
                                      dispositionPrediction_wCC$`cc_withdrawal-alcohol` 
  

dispositionPrediction_wCC$cc_endo <- dispositionPrediction_wCC$`cc_decreasedbloodsugar-symptomatic` +
                                     dispositionPrediction_wCC$`cc_elevatedbloodsugar-nosymptoms` + 
                                     dispositionPrediction_wCC$`cc_elevatedbloodsugar-symptomatic` + 
                                     dispositionPrediction_wCC$cc_hyperglycemia

dispositionPrediction_wCC$cc_heme <- dispositionPrediction_wCC$`cc_bleeding/bruising` +
                                     dispositionPrediction_wCC$cc_sicklecellpain

dispositionPrediction_wCC$cc_traumaMajor <- dispositionPrediction_wCC$cc_assaultvictim +
                                            dispositionPrediction_wCC$cc_burn +
                                            dispositionPrediction_wCC$cc_fall +
                                            dispositionPrediction_wCC$`cc_fall>65` +
                                            dispositionPrediction_wCC$cc_fulltrauma +
                                            dispositionPrediction_wCC$cc_headinjury +
                                            dispositionPrediction_wCC$cc_headlaceration +
                                            dispositionPrediction_wCC$cc_modifiedtrauma +
                                            dispositionPrediction_wCC$cc_motorcyclecrash +
                                            dispositionPrediction_wCC$cc_motorvehiclecrash +
                                            dispositionPrediction_wCC$cc_multiplefalls +
                                            dispositionPrediction_wCC$cc_trauma
                                           

dispositionPrediction_wCC$cc_traumaMinor <- dispositionPrediction_wCC$cc_animalbite +
                                            dispositionPrediction_wCC$cc_arminjury +
                                            dispositionPrediction_wCC$cc_ankleinjury +
                                            dispositionPrediction_wCC$cc_extremitylaceration +
                                            dispositionPrediction_wCC$cc_eyeinjury +
                                            dispositionPrediction_wCC$cc_facialinjury +
                                            dispositionPrediction_wCC$cc_faciallaceration +
                                            dispositionPrediction_wCC$cc_fingerinjury +
                                            dispositionPrediction_wCC$cc_footinjury +
                                            dispositionPrediction_wCC$cc_handinjury +
                                            dispositionPrediction_wCC$cc_insectbite +
                                            dispositionPrediction_wCC$cc_kneeinjury +
                                            dispositionPrediction_wCC$cc_laceration +
                                            dispositionPrediction_wCC$cc_leginjury +
                                            dispositionPrediction_wCC$cc_ribinjury +
                                            dispositionPrediction_wCC$cc_shoulderinjury +
                                            dispositionPrediction_wCC$cc_thumbinjury +
                                            dispositionPrediction_wCC$cc_toeinjury +
                                            dispositionPrediction_wCC$cc_wristinjury 

dispositionPrediction_wCC$cc_otherFull <- dispositionPrediction_wCC$cc_abnormallab +
                                          dispositionPrediction_wCC$cc_allergicreaction +
                                          dispositionPrediction_wCC$cc_bodyfluidexposure +
                                          dispositionPrediction_wCC$cc_dehydration +
                                          dispositionPrediction_wCC$cc_drugproblem +
                                          dispositionPrediction_wCC$cc_edema +
                                          dispositionPrediction_wCC$cc_medicalproblem +
                                          dispositionPrediction_wCC$cc_medicalscreening +
                                          dispositionPrediction_wCC$cc_medicationproblem +
                                          dispositionPrediction_wCC$cc_medicationrefill +
                                          dispositionPrediction_wCC$cc_other +
                                          dispositionPrediction_wCC$`cc_overdose-accidental` +
                                          dispositionPrediction_wCC$`cc_overdose-intentional` +
                                          dispositionPrediction_wCC$`cc_poisoning` +
                                          dispositionPrediction_wCC$`cc_post-opproblem` +
                                          dispositionPrediction_wCC$`cc_suture/stapleremoval` +
                                          dispositionPrediction_wCC$`cc_tickremoval` 

#Only keep the reduced columns and clean up names 
dispositionPrediction_wCC <- subset(dispositionPrediction_wCC, select = c(  disposition,
                                                                            age,
                                                                            gender,
                                                                            ethnicity,
                                                                            race,
                                                                            lang,
                                                                            religion,
                                                                            maritalstatus,
                                                                            employstatus,
                                                                            insurance_status,
                                                                            dep_name,
                                                                            arrivalmode,
                                                                            arrivalmonth,
                                                                            arrivalday,
                                                                            arrivalhour_bin,
                                                                            triage_vital_hr,
                                                                            triage_vital_sbp,
                                                                            triage_vital_dbp,
                                                                            triage_vital_rr,
                                                                            triage_vital_o2,
                                                                            triage_vital_o2_device,
                                                                            triage_vital_temp,
                                                                            esi,
                                                                            cc_const,
                                                                            cc_heent,
                                                                            cc_cardiovasc,
                                                                            cc_resp,
                                                                            cc_gi,
                                                                            cc_gu,
                                                                            cc_msk,
                                                                            cc_derm,
                                                                            cc_neuro,
                                                                            cc_psych,
                                                                            cc_endo,
                                                                            cc_heme,
                                                                            cc_traumaMajor,
                                                                            cc_traumaMinor,
                                                                            cc_otherFull,
                                                                            previousdispo,
                                                                            n_edvisits,
                                                                            n_admissions,
                                                                            n_surgeries
                                                                            ))

names(dispositionPrediction_wCC)[names(dispositionPrediction_wCC)=="cc_otherFull"] <- "cc_other"

#End appending CCs ####

'
Prepare targets: 
'

#Since will be comparing agaisnt the ESI, drop all rows where patient's don't have an ESI score
nMissing_esi = sum(is.na(dispositionPrediction_wCC$esi)) #Only losing 2457 rows
dispositionPrediction_wCC <- dispositionPrediction_wCC[!is.na(dispositionPrediction_wCC$esi),]

#End preparing targets ####


'
Prepare predictors: 

' 
#Begin recoding levels of categorical variables ####
#Rename [Other] to [Hispanic or Latino]
levels(dispositionPrediction_wCC$race)[levels(dispositionPrediction_wCC$race)=="Other"] <- "Hispanic or Latino"

#Fold [various Christian sects] into [Christian]
levels(dispositionPrediction_wCC$religion) <- list("Christian" = c("Baptist", "Catholic", "Christian", "Episcopal","Jehovah's Witness", "Methodist", "Pentecostal", "Protestant"), 
                                                   "Jewish" = c("Jewish"), 
                                                   "Muslim" = c("Muslim"), 
                                                   "None" = c("None"), 
                                                   "Other" = c("Other"), 
                                                   "Unknown" = c("Unknown"))

#Fold [various student types] into [student] and [On Active Military Duty] into [Full Time]
levels(dispositionPrediction_wCC$employstatus) <- list ("Disabled" = c("Disabled"),
                                                        "Full Time" = c("Full Time", "On Active Military Duty"),
                                                        "Part Time" = c("Part Time"),
                                                        "Retired" = c("Retired"),
                                                        "Self Employed" = c("Self Employed"),
                                                        "Student" = c("Student - Full Time", "Student - Part Time"),
                                                        "Unknown" = c("Unknown"))

#Fold [Civil Union + Life Partner + Married + Significant Other] into [In Relationship], 
#[Single],  [Legally Separated + Divorced + Widowed] into [Out of Relationship], [Unknown]
levels(dispositionPrediction_wCC$maritalstatus) <- list("In Relationship" = c("Civil Union","Life Partner", "Significant Other", "Married"),
                                                        "Single" = c("Single"),
                                                        "Out of Relationship" = c("Divorced", "Legally Separated", "Widowed "),
                                                        "Other" = c("Other"),
                                                        "Unknown" = c("Unknown"))

#Fold arrival days into [weekday] and [weekend]
levels(dispositionPrediction_wCC$arrivalday) <- list("Weekday" = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),
                                                     "Weekend" = c("Saturday", "Sunday"))

#Fold arrival times into [day] and [night]
levels(dispositionPrediction_wCC$arrivalhour_bin) <- list("Day" = c("07-10", "11-14", "15-18"),
                                                          "Night" = c("19-22", 23-02, 03-06))
names(dispositionPrediction_wCC)[names(dispositionPrediction_wCC)=="arrivalhour_bin"] <- "arrivaltime"

#End recoding levels of categorical variables #### 


#Check and address missingness in predictors ####
#Check and address missingness in demographics
nMissing_maritalstatus = sum(is.na(dispositionPrediction_wCC$maritalstatus)) #50428 -> RECAT
nMissing_employstatus = sum(is.na(dispositionPrediction_wCC$employstatus)) #154059 -> RECAT
nMissing_race = sum(is.na(dispositionPrediction_wCC$race)) #22 -> RECAT
nMissing_religion = sum(is.na(dispositionPrediction_wCC$religion)) #0 -> YEET 
nMissing_insurance = sum(is.na(dispositionPrediction_wCC$insurance_status)) #0 -> YEET
nMissing_gender = sum(is.na(dispositionPrediction_wCC$gender)) #0 -> YEET
nMissing_age = sum(is.na(dispositionPrediction_wCC$age)) #11 -> DROP 

dispositionPrediction_wCC <- dispositionPrediction_wCC[!is.na(dispositionPrediction_wCC$age),] #Drop missing ages
dispositionPrediction_wCC$maritalstatus[is.na(dispositionPrediction_wCC$maritalstatus)] <- "Unknown" #Recat missing marital
dispositionPrediction_wCC$employstatus[is.na(dispositionPrediction_wCC$employstatus)] <- "Unknown" #Recat missing employment
dispositionPrediction_wCC$race[is.na(dispositionPrediction_wCC$race)] <- "Unknown" #Recat missing race

#Check missingness hospital usage
nMissing_prevDisp = sum(is.na(dispositionPrediction_wCC$previousdispo)) #0 -> YEET
nMissing_nEDVis = sum(is.na(dispositionPrediction_wCC$n_edvisits)) #0 -> YEET
nMissing_nAds = sum(is.na(dispositionPrediction_wCC$n_admissions)) #0 -> YEET 
nMissing_nSurg = sum(is.na(dispositionPrediction_wCC$n_surgeries)) #0 -> YEET 

#Check missing arrival indicators
nMissing_arrivalMode = sum(is.na(dispositionPrediction_wCC$arrivalmode)) #20798 -> DROP
nMissing_arrivalDay = sum(is.na(dispositionPrediction_wCC$arrivalday)) #0 -> YEET
nMissing_arrivalTime = sum(is.na(dispositionPrediction_wCC$arrivaltime)) #81437 -> DROP 

dispositionPrediction_wCC <- dispositionPrediction_wCC[!is.na(dispositionPrediction_wCC$arrivalmode),] #Drop missing arrival modes
dispositionPrediction_wCC <- dispositionPrediction_wCC[!is.na(dispositionPrediction_wCC$arrivaltime),] #Drop missing arrival times

#Check missingness triage
nMissing_nHR = sum(is.na(dispositionPrediction_wCC$triage_vital_hr)) #164261
nMissing_nSBP = sum(is.na(dispositionPrediction_wCC$triage_vital_sbp)) #166107
nMissing_nDBP = sum(is.na(dispositionPrediction_wCC$triage_vital_dbp)) #166266
nMissing_nRR = sum(is.na(dispositionPrediction_wCC$triage_vital_rr)) #168665
nMissing_nO2 = sum(is.na(dispositionPrediction_wCC$triage_vital_o2)) #269363 
nMissing_nTemp = sum(is.na(dispositionPrediction_wCC$triage_vital_temp)) #181148

#End checking and addressing missingness of predictor variables ####

#Drop useless columns, ethicity, triage_vital_o2_device, arrivalmonth
dispositionPrediction_wCC <- subset(dispositionPrediction_wCC, select = -c(ethnicity, triage_vital_o2_device, arrivalmonth))

#Finish preparing predictors ####

'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OUTCOME 2:  PREDICTING POLYPHARMACY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'

#Create working df####
rxPred = subset(df, select = c( 
                                  disposition,
                                  age,
                                  gender,
                                  ethnicity,
                                  race,
                                  lang,
                                  religion,
                                  maritalstatus,
                                  employstatus,
                                  insurance_status,
                                  dep_name,
                                  arrivalmode,
                                  arrivalmonth,
                                  arrivalday,
                                  arrivalhour_bin,
                                  triage_vital_hr,
                                  triage_vital_sbp,
                                  triage_vital_dbp,
                                  triage_vital_rr,
                                  triage_vital_o2,
                                  triage_vital_o2_device,
                                  triage_vital_temp,
                                  esi,
                                  previousdispo,
                                  n_edvisits,
                                  n_admissions,
                                  n_surgeries)) 

#Apprend Rx and CCs
ccdf = df[ , grepl( "cc_" , names( df ) ) ]
rxdf = df[ , grepl( "meds_" , names( df ) ) ]
rxPred = cbind(rxPred, rxdf)
rxPred_wCC = cbind(rxPred, ccdf)


#Clean meds ####
rxPred_wCC$n_meds <- rxPred_wCC$meds_analgesicandantihistaminecombination +
                     rxPred_wCC$meds_analgesics +
                     rxPred_wCC$meds_anesthetics +
                     rxPred_wCC$`meds_anti-obesitydrugs` +
                     rxPred_wCC$meds_antiallergy +
                     rxPred_wCC$meds_antiarthritics +
                     rxPred_wCC$meds_antiasthmatics +
                     rxPred_wCC$meds_antibiotics +
                     rxPred_wCC$meds_anticoagulants +
                     rxPred_wCC$meds_antidotes +
                     rxPred_wCC$meds_antifungals +
                     rxPred_wCC$meds_antihistamineanddecongestantcombination +
                     rxPred_wCC$meds_antihistamines +
                     rxPred_wCC$meds_antihyperglycemics +
                     rxPred_wCC$meds_antiinfectives +
                     rxPred_wCC$`meds_antiinfectives/miscellaneous` +
                     rxPred_wCC$meds_antineoplastics +
                     rxPred_wCC$meds_antiparkinsondrugs +
                     rxPred_wCC$meds_antiplateletdrugs +
                     rxPred_wCC$meds_antivirals +
                     rxPred_wCC$meds_autonomicdrugs +
                     rxPred_wCC$meds_biologicals +
                     rxPred_wCC$meds_blood +
                     rxPred_wCC$meds_cardiacdrugs +
                     rxPred_wCC$meds_cardiovascular +
                     rxPred_wCC$meds_cnsdrugs +
                     rxPred_wCC$meds_colonystimulatingfactors +
                     rxPred_wCC$meds_contraceptives +
                     rxPred_wCC$`meds_cough/coldpreparations` +
                     rxPred_wCC$meds_diagnostic +
                     rxPred_wCC$meds_diuretics +
                     rxPred_wCC$meds_eentpreps +
                     rxPred_wCC$`meds_elect/caloric/h2o` +
                     rxPred_wCC$meds_gastrointestinal +
                     rxPred_wCC$meds_herbals +
                     rxPred_wCC$meds_hormones +
                     rxPred_wCC$meds_immunosuppressants +
                     rxPred_wCC$meds_investigational +
                     rxPred_wCC$`meds_miscellaneousmedicalsupplies,devices,non-drug` +
                     rxPred_wCC$meds_musclerelaxants +
                     rxPred_wCC$`meds_pre-natalvitamins` +
                     rxPred_wCC$meds_psychotherapeuticdrugs +
                     rxPred_wCC$`meds_sedative/hypnotics`+
                     rxPred_wCC$meds_skinpreps +
                     rxPred_wCC$meds_smokingdeterrents +
                     rxPred_wCC$meds_thyroidpreps +
                     rxPred_wCC$meds_unclassifieddrugproducts +
                     rxPred_wCC$meds_vitamins

#Clean CCs ####
rxPred_wCC$cc_const <- rxPred_wCC$cc_chills + 
                       rxPred_wCC$cc_fatigue +
                       rxPred_wCC$cc_fever +
                       rxPred_wCC$`cc_fever-75yearsorolder` +
                       rxPred_wCC$`cc_fever-9weeksto74years` +
                       rxPred_wCC$cc_feverimmunocompromised +
                       rxPred_wCC$cc_generalizedbodyaches +
                       rxPred_wCC$cc_lethargy +
                       rxPred_wCC$cc_lossofconsciousness +
                       rxPred_wCC$cc_mass +
                       rxPred_wCC$cc_pain +
                       rxPred_wCC$cc_unresponsive +
                       rxPred_wCC$cc_weakness

rxPred_wCC$cc_heent <- rxPred_wCC$cc_blurredvision + 
                       rxPred_wCC$cc_conjunctivitis + 
                       rxPred_wCC$cc_dentalpain +
                       rxPred_wCC$cc_dizziness +
                       rxPred_wCC$cc_earpain +
                       rxPred_wCC$cc_earproblem +
                       rxPred_wCC$cc_epistaxis +
                       rxPred_wCC$cc_eyepain +
                       rxPred_wCC$cc_eyeproblem +
                       rxPred_wCC$cc_eyeredness +
                       rxPred_wCC$cc_facialpain +
                       rxPred_wCC$cc_facialswelling +
                       rxPred_wCC$cc_foreignbodyineye +
                       rxPred_wCC$cc_headache +
                       rxPred_wCC$`cc_headache-newonsetornewsymptoms` +
                       rxPred_wCC$`cc_headache-recurrentorknowndxmigraines` +
                       rxPred_wCC$`cc_headachere-evaluation` +
                       rxPred_wCC$cc_jawpain +
                       rxPred_wCC$cc_migraine +
                       rxPred_wCC$cc_nasalcongestion +
                       rxPred_wCC$cc_neckpain +
                       rxPred_wCC$cc_oralswelling +
                       rxPred_wCC$cc_otalgia +
                       rxPred_wCC$cc_sinusproblem +
                       rxPred_wCC$cc_sorethroat

rxPred_wCC$cc_cardiovasc <- rxPred_wCC$cc_cardiacarrest + 
                            rxPred_wCC$cc_chestpain + 
                            rxPred_wCC$cc_chesttightness + 
                            rxPred_wCC$cc_hypertension + 
                            rxPred_wCC$cc_hypotension + 
                            rxPred_wCC$cc_irregularheartbeat + 
                            rxPred_wCC$cc_nearsyncope + 
                            rxPred_wCC$cc_palpitations + 
                            rxPred_wCC$cc_rapidheartrate + 
                            rxPred_wCC$cc_syncope +
                            rxPred_wCC$cc_tachycardia

rxPred_wCC$cc_resp <- rxPred_wCC$cc_asthma + 
                      rxPred_wCC$cc_breathingdifficulty + 
                      rxPred_wCC$cc_breathingproblem + 
                      rxPred_wCC$cc_coldlikesymptoms + 
                      rxPred_wCC$cc_cough + 
                      rxPred_wCC$cc_dyspnea + 
                      rxPred_wCC$cc_hemoptysis + 
                      rxPred_wCC$cc_influenza + 
                      rxPred_wCC$cc_respiratorydistress + 
                      rxPred_wCC$cc_shortnessofbreath +
                      rxPred_wCC$cc_wheezing +
                      rxPred_wCC$cc_uri

rxPred_wCC$cc_gi <- rxPred_wCC$cc_abdominalcramping +
                    rxPred_wCC$cc_abdominaldistention +
                    rxPred_wCC$cc_abdominalpain +
                    rxPred_wCC$cc_abdominalpainpregnant +
                    rxPred_wCC$cc_constipation +
                    rxPred_wCC$cc_diarrhea +
                    rxPred_wCC$cc_emesis +
                    rxPred_wCC$cc_epigastricpain +
                    rxPred_wCC$cc_gibleeding +
                    rxPred_wCC$cc_giproblem +
                    rxPred_wCC$cc_ingestion +
                    rxPred_wCC$cc_nausea +
                    rxPred_wCC$cc_rectalbleeding +
                    rxPred_wCC$cc_rectalpain +
                    rxPred_wCC$cc_swallowedforeignbody

rxPred_wCC$cc_gu <- rxPred_wCC$cc_dysuria +
                    rxPred_wCC$cc_exposuretostd +
                    rxPred_wCC$cc_femaleguproblem +
                    rxPred_wCC$cc_flankpain +
                    rxPred_wCC$cc_groinpain +
                    rxPred_wCC$cc_hematuria +
                    rxPred_wCC$cc_maleguproblem +
                    rxPred_wCC$cc_pelvicpain +
                    rxPred_wCC$cc_stdcheck +
                    rxPred_wCC$cc_testiclepain +
                    rxPred_wCC$cc_urinaryfrequency +
                    rxPred_wCC$cc_urinaryretention +
                    rxPred_wCC$cc_urinarytractinfection +
                    rxPred_wCC$cc_vaginalbleeding +
                    rxPred_wCC$cc_vaginaldischarge + 
                    rxPred_wCC$cc_vaginalpain

rxPred_wCC$cc_msk <- rxPred_wCC$cc_anklepain +
                     rxPred_wCC$cc_armpain +
                     rxPred_wCC$cc_armswelling +
                     rxPred_wCC$cc_backpain +
                     rxPred_wCC$cc_elbowpain +
                     rxPred_wCC$cc_fingerpain +
                     rxPred_wCC$cc_fingerswelling +
                     rxPred_wCC$cc_footpain +
                     rxPred_wCC$cc_footswelling +
                     rxPred_wCC$cc_handpain +
                     rxPred_wCC$cc_hippain +
                     rxPred_wCC$cc_jointswelling +
                     rxPred_wCC$cc_kneepain +
                     rxPred_wCC$cc_legpain +
                     rxPred_wCC$cc_legswelling +
                     rxPred_wCC$cc_ribpain +
                     rxPred_wCC$cc_shoulderpain +
                     rxPred_wCC$cc_toepain +
                     rxPred_wCC$cc_wristpain

rxPred_wCC$cc_derm <- rxPred_wCC$cc_breastpain +
                      rxPred_wCC$cc_cellulitis +
                      rxPred_wCC$cc_abscess +
                      rxPred_wCC$cc_cyst +
                      rxPred_wCC$`cc_follow-upcellulitis` +
                      rxPred_wCC$cc_rash +
                      rxPred_wCC$cc_skinirritation +
                      rxPred_wCC$cc_skinproblem +
                      rxPred_wCC$cc_woundcheck +
                      rxPred_wCC$cc_woundinfection +
                      rxPred_wCC$`cc_woundre-evaluation`

rxPred_wCC$cc_neuro <- rxPred_wCC$cc_confusion +
                       rxPred_wCC$cc_extremityweakness +
                       rxPred_wCC$cc_neurologicproblem +
                       rxPred_wCC$cc_numbness +
                       rxPred_wCC$`cc_seizure-newonset`+
                       rxPred_wCC$`cc_seizure-priorhxof` +
                       rxPred_wCC$cc_seizures +
                       rxPred_wCC$cc_strokealert

rxPred_wCC$cc_psych <- rxPred_wCC$cc_addictionproblem +
                       rxPred_wCC$cc_agitation +
                       rxPred_wCC$cc_alteredmentalstatus +
                       rxPred_wCC$cc_alcoholintoxication +
                       rxPred_wCC$cc_alcoholproblem +
                       rxPred_wCC$cc_anxiety +
                       rxPred_wCC$cc_depression +
                       rxPred_wCC$cc_detoxevaluation +
                       rxPred_wCC$`cc_drug/alcoholassessment` +
                       rxPred_wCC$cc_hallucinations +
                       rxPred_wCC$cc_homicidal +
                       rxPred_wCC$cc_panicattack +
                       rxPred_wCC$cc_psychiatricevaluation +
                       rxPred_wCC$cc_psychoticsymptoms +
                       rxPred_wCC$cc_suicidal +
                       rxPred_wCC$`cc_withdrawal-alcohol` 


rxPred_wCC$cc_endo <- rxPred_wCC$`cc_decreasedbloodsugar-symptomatic` +
                      rxPred_wCC$`cc_elevatedbloodsugar-nosymptoms` + 
                      rxPred_wCC$`cc_elevatedbloodsugar-symptomatic` + 
                      rxPred_wCC$cc_hyperglycemia

rxPred_wCC$cc_heme <- rxPred_wCC$`cc_bleeding/bruising` +
                      rxPred_wCC$cc_sicklecellpain

rxPred_wCC$cc_traumaMajor <- rxPred_wCC$cc_assaultvictim +
                             rxPred_wCC$cc_burn +
                             rxPred_wCC$cc_fall +
                             rxPred_wCC$`cc_fall>65` +
                             rxPred_wCC$cc_fulltrauma +
                             rxPred_wCC$cc_headinjury +
                             rxPred_wCC$cc_headlaceration +
                             rxPred_wCC$cc_modifiedtrauma +
                             rxPred_wCC$cc_motorcyclecrash +
                             rxPred_wCC$cc_motorvehiclecrash +
                             rxPred_wCC$cc_multiplefalls +
                             rxPred_wCC$cc_trauma


rxPred_wCC$cc_traumaMinor <- rxPred_wCC$cc_animalbite +
                             rxPred_wCC$cc_arminjury +
                             rxPred_wCC$cc_ankleinjury +
                             rxPred_wCC$cc_extremitylaceration +
                             rxPred_wCC$cc_eyeinjury +
                             rxPred_wCC$cc_facialinjury +
                             rxPred_wCC$cc_faciallaceration +
                             rxPred_wCC$cc_fingerinjury +
                             rxPred_wCC$cc_footinjury +
                             rxPred_wCC$cc_handinjury +
                             rxPred_wCC$cc_insectbite +
                             rxPred_wCC$cc_kneeinjury +
                             rxPred_wCC$cc_laceration +
                             rxPred_wCC$cc_leginjury +
                             rxPred_wCC$cc_ribinjury +
                             rxPred_wCC$cc_shoulderinjury +
                             rxPred_wCC$cc_thumbinjury +
                             rxPred_wCC$cc_toeinjury +
                             rxPred_wCC$cc_wristinjury 

rxPred_wCC$cc_otherFull <- rxPred_wCC$cc_abnormallab +
                           rxPred_wCC$cc_allergicreaction +
                           rxPred_wCC$cc_bodyfluidexposure +
                           rxPred_wCC$cc_dehydration +
                           rxPred_wCC$cc_drugproblem +
                           rxPred_wCC$cc_edema +
                           rxPred_wCC$cc_medicalproblem +
                           rxPred_wCC$cc_medicalscreening +
                           rxPred_wCC$cc_medicationproblem +
                           rxPred_wCC$cc_medicationrefill +
                           rxPred_wCC$cc_other +
                           rxPred_wCC$`cc_overdose-accidental` +
                           rxPred_wCC$`cc_overdose-intentional` +
                           rxPred_wCC$`cc_poisoning` +
                           rxPred_wCC$`cc_post-opproblem` +
                           rxPred_wCC$`cc_suture/stapleremoval` +
                           rxPred_wCC$`cc_tickremoval` 


#Drop unnecessary cols ####
rxPred_wCC = subset(rxPred_wCC, select = c( age,
                                            gender,
                                            ethnicity,
                                            race,
                                            lang,
                                            religion,
                                            maritalstatus,
                                            employstatus,
                                            insurance_status,
                                            dep_name,
                                            arrivalmode,
                                            arrivalday,
                                            arrivalhour_bin,
                                            triage_vital_hr,
                                            triage_vital_sbp,
                                            triage_vital_dbp,
                                            triage_vital_rr,
                                            triage_vital_o2,
                                            triage_vital_temp,
                                            esi,
                                            previousdispo,
                                            n_edvisits,
                                            n_admissions,
                                            n_surgeries,
                                            cc_const,
                                            cc_heent,
                                            cc_cardiovasc,
                                            cc_resp,
                                            cc_gi,
                                            cc_gu,
                                            cc_msk,
                                            cc_derm,
                                            cc_neuro,
                                            cc_psych,
                                            cc_endo,
                                            cc_heme,
                                            cc_traumaMajor,
                                            cc_traumaMinor,
                                            cc_otherFull,
                                            n_meds)) 

names(rxPred_wCC)[names(rxPred_wCC)=="cc_otherFull"] <- "cc_other"

#Apply cleaning from before to recategorize levels in cat vars, drop useless vars, and address missingness  ####
#Drop if missing ESI
rxPred_wCC <- rxPred_wCC[!is.na(rxPred_wCC$esi),]

#Recode categorical variables
levels(rxPred_wCC$race)[levels(rxPred_wCC$race)=="Other"] <- "Hispanic or Latino"

levels(rxPred_wCC$religion) <- list("Christian" = c("Baptist", "Catholic", "Christian", "Episcopal","Jehovah's Witness", "Methodist", "Pentecostal", "Protestant"), 
                                                    "Jewish" = c("Jewish"), 
                                                    "Muslim" = c("Muslim"), 
                                                    "None" = c("None"), 
                                                    "Other" = c("Other"), 
                                                    "Unknown" = c("Unknown"))

levels(rxPred_wCC$employstatus) <- list ("Disabled" = c("Disabled"),
                                                        "Full Time" = c("Full Time", "On Active Military Duty"),
                                                        "Part Time" = c("Part Time"),
                                                        "Retired" = c("Retired"),
                                                        "Self Employed" = c("Self Employed"),
                                                        "Student" = c("Student - Full Time", "Student - Part Time"),
                                                        "Unknown" = c("Unknown"))

levels(rxPred_wCC$maritalstatus) <- list("In Relationship" = c("Civil Union","Life Partner", "Significant Other", "Married"),
                                          "Single" = c("Single"),
                                          "Out of Relationship" = c("Divorced", "Legally Separated", "Widowed "),
                                          "Other" = c("Other"),
                                          "Unknown" = c("Unknown"))

levels(rxPred_wCC$arrivalday) <- list("Weekday" = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),
                                      "Weekend" = c("Saturday", "Sunday"))

levels(rxPred_wCC$arrivalhour_bin) <- list("Day" = c("07-10", "11-14", "15-18"),
                                           "Night" = c("19-22", 23-02, 03-06))
names(rxPred_wCC)[names(rxPred_wCC)=="arrivalhour_bin"] <- "arrivaltime"

#Drop or recat based on missing values 
rxPred_wCC <- rxPred_wCC[!is.na(rxPred_wCC$age),] 
rxPred_wCC$maritalstatus[is.na(rxPred_wCC$maritalstatus)] <- "Unknown" 
rxPred_wCC$employstatus[is.na(rxPred_wCC$employstatus)] <- "Unknown"
rxPred_wCC$race[is.na(rxPred_wCC$race)] <- "Unknown"
rxPred_wCC <- rxPred_wCC[!is.na(rxPred_wCC$arrivalmode),]
rxPred_wCC <- rxPred_wCC[!is.na(rxPred_wCC$arrivaltime),]
#End cleaning from outcome 1 ####

#Restrict to over pts over 50, as they are at higher risk
rxPred_wCC <- subset(rxPred_wCC, rxPred_wCC$age > 49)

'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXPORT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'
#Export files to .csv to read into SAS
write.csv(dispositionPrediction_wCC,'dispPred.csv')
write.csv(rxPred_wCC, 'rxPred.csv')
save(dispositionPrediction_wCC, file="dispPred.Rda")
save(rxPred_wCC, file="rxPred.Rda")

