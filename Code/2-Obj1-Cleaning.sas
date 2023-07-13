/* Final - Objective 1 Data Cleaning Script */;
/* By:  VH    Date Modified: May 8 20*/;

libname final "/folders/myfolders/Biostats2/Final";
run;

'''Recode categorical variables into numerics''';
'''Demographics''';
data final.dispPredCleaned;
   set final.dispPred;
   
   if gender='Male' then sex=0;
   if gender='Female' then sex=1;
   drop gender;
   
   if race='White or Caucasian' then race_n=0;
   if race='Black or African American' then race_n=1;
   if race='Hispanic or Latino' then race_n=2;
   if race='Other' then race_n=3;
   if race='Unknown' then race_n=4;
   
   if lang='English' then lang_n=0;
   if lang='Other' then lang_n=1;
   
   drop religion;
   drop maritalstatus;
   
   if employstatus='Full Time' then employstatus_n=0;
   if employstatus='Part Time' then employstatus_n=1;
   if employstatus='Retired' then employstatus_n=2;
   if employstatus='Self Employ' then employstatus_n=3;
   if employstatus='Student' then employstatus_n=4;
   if employstatus='Disabled' then employstatus_n=5;
   if employstatus='Unknown' then employstatus_n=6;
   
   if insurance_status='Commercial' then insurance_status_n=0;
   if insurance_status='Medicaid' then insurance_status_n=1;
   if insurance_status='Medicare' then insurance_status_n=2;
   if insurance_status='Other' then insurance_status_n=3;
   if insurance_status='Self pay' then insurance_status_n=4;
   
   drop race lang employstatus insurance_status;
   rename race_n=race lang_n=lang employstatus_n=employstatus insurance_status_n=insurance_status;
run;

'''Triage''';
data final.dispPredCleaned;
   set final.dispPredCleaned;
   
   if dep_name='Freestanding ER' then dep_name_n=0;
   if dep_name='Community Hospital' then dep_name_n=1;
   if dep_name='Level 1 Trauma Center' then dep_name_n=2;
   
   if arrivalmode='Walk-in' then arrivalmode_n=0;
   if arrivalmode='Other' then arrivalmode_n=1;
   if arrivalmode='Car' then arrivalmode_n=2;
   if arrivalmode='Emergency Services' then arrivalmode_n=3;
   
   if arrivaltime='Day' then arrivaltime_n=0;
   if arrivaltime='Night' then arrivaltime_n=1;
   
   if arrivalday='Weekday' then arrivalday_n=0;
   if arrivalday='Weekend' then arrivalday_n=1;
   
   if esi='1' then esi_n=1;
   if esi='2' then esi_n=2;
   if esi='3' then esi_n=3;
   if esi='4' then esi_n=4;
   if esi='5' then esi_n=5;
   
   if chief_complaint='cc_other' then chief_complaint_n = 0;
   if chief_complaint='cc_const' then chief_complaint_n = 1;
   if chief_complaint='cc_heent' then chief_complaint_n = 2;
   if chief_complaint='cc_cardiovasc' then chief_complaint_n = 3;
   if chief_complaint='cc_resp' then chief_complaint_n = 4;
   if chief_complaint='cc_gi' then chief_complaint_n = 5;
   if chief_complaint='cc_gu' then chief_complaint_n = 6;
   if chief_complaint='cc_msk' then chief_complaint_n = 7;
   if chief_complaint='cc_derm' then chief_complaint_n = 8;
   if chief_complaint='cc_neuro' then chief_complaint_n = 9;
   if chief_complaint='cc_psych' then chief_complaint_n = 10;
   if chief_complaint='cc_endo' then chief_complaint_n = 11;
   if chief_complaint='cc_heme' then chief_complaint_n = 12;
   if chief_complaint='cc_traumaMajor' then chief_complaint_n = 13;
   if chief_complaint='cc_traumaMinor' then chief_complaint_n = 14;
   
   drop dep_name arrivalmode arrivaltime arrivalday esi chief_complaint;
   rename dep_name_n = dep_name arrivalmode_n = arrivalmode arrivaltime_n = arrivaltime arrivalday_n = arrivalday esi_n=esi chief_complaint_n=chief_complaint;
 run;
 
 '''Healthcare Usage''';
 data final.dispPredCleaned;
   set final.dispPredCleaned;
   
   if previousdispo='No previous disposition' then previousdispo_n=0;
   if previousdispo='Admit' then previousdispo_n=1;
   if previousdispo='Discharge' then previousdispo_n=2;
   
   drop previousdispo;
   rename previousdispo_n = previousdispo;
 run;
 
  '''Outcome''';
 data final.dispPredCleaned;
   set final.dispPredCleaned;
   
   if disposition='Discharge' then disposition_n=0;
   if disposition='Admit' then disposition_n=1;
   
   drop disposition;
   rename disposition_n = disposition;
 run;

 '''Drop random variable''';
  data final.dispPredCleaned;
   set final.dispPredCleaned;
   drop VAR1;
  run;
