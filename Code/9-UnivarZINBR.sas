/* Final - Univariate Zero-Inflated Negative Binomial Regression Script */;
/* By:  VH    Date Modified: May 9 20*/;

libname final "/folders/myfolders/Biostats2/Final";
run;

/*Demographics*/
proc genmod data = final.rxPred;
  class gender(ref='Male');
  model n_meds = gender /dist=zinb;
  zeromodel gender;
run;

proc genmod data = final.rxPred;
  model n_meds = age /dist=zinb;
  zeromodel age;
run;

proc genmod data = final.rxPred;
  class race(ref='White or Caucasian');
  model n_meds = race /dist=zinb;
  zeromodel race;
run;

proc genmod data = final.rxPred;
  class lang(ref='English');
  model n_meds = lang /dist=zinb;
  zeromodel lang;
run;

proc genmod data = final.rxPred;
  class employstatus(ref='Full Time');
  model n_meds = employstatus /dist=zinb;
  zeromodel employstatus;
run;

proc genmod data = final.rxPred;
  class insurance_status(ref='Commercial');
  model n_meds = insurance_status /dist=zinb;
  zeromodel insurance_status;
run;

proc genmod data = final.rxPred;
  class maritalstatus(ref='In Relationship');
  model n_meds = maritalstatus /dist=zinb;
  zeromodel maritalstatus;
run;

/*Triage Information*/
proc genmod data = final.rxPred;
  class dep_name(ref='Freestanding ER');
  model n_meds = dep_name /dist=zinb;
  zeromodel dep_name;
run;

proc genmod data = final.rxPred;
  class arrivalmode(ref='Walk-in');
  model n_meds = arrivalmode /dist=zinb;
  zeromodel arrivalmode;
run;

proc genmod data = final.rxPred;
  class arrivalday(ref='Weekday');
  model n_meds = arrivalday /dist=zinb;
  zeromodel arrivalday;
run;

proc genmod data = final.rxPred;
  class arrivaltime(ref='Day');
  model n_meds = arrivaltime /dist=zinb;
  zeromodel arrivaltime;
run;

proc genmod data = final.rxPred;
  class esi(ref='3');
  model n_meds = esi /dist=zinb;
  zeromodel esi;
run;

proc genmod data = final.rxPred;
  class chief_complaint(ref='cc_other');
  model n_meds = chief_complaint /dist=zinb;
  zeromodel chief_complaint;
run;

proc genmod data = final.rxPred;
  model n_meds = triage_vital_HR /dist=zinb;
  zeromodel triage_vital_HR;
run;

proc genmod data = final.rxPred;
  model n_meds = triage_vital_SBP /dist=zinb;
  zeromodel triage_vital_SBP;
run;

proc genmod data = final.rxPred;
  model n_meds = triage_vital_DBP /dist=zinb;
  zeromodel triage_vital_DBP;
run;

proc genmod data = final.rxPred;
  model n_meds = triage_vital_RR /dist=zinb;
  zeromodel triage_vital_RR;
run;

proc genmod data = final.rxPred;
  model n_meds = triage_vital_O2 /dist=zinb;
  zeromodel triage_vital_O2;
run;

proc genmod data = final.rxPred;
  model n_meds = triage_vital_Temp /dist=zinb;
  zeromodel triage_vital_Temp;
run;


proc genmod data = final.rxPred;
  model n_meds = n_complaints /dist=zinb;
  zeromodel n_complaints;
run;


/*Healthcare Usage*/
proc genmod data = final.rxPred;
  class previousdispo(ref='No previous disposition');
  model n_meds = previousdispo /dist=zinb;
  zeromodel previousdispo;
run;

proc genmod data = final.rxPred;
  model n_meds = n_edvisits /dist=zinb;
  zeromodel n_edvisits;
run;

proc genmod data = final.rxPredVitalsCoded;
  model n_meds = n_admissions /dist=zinb;
  zeromodel n_admissions;
run;

proc genmod data = final.rxPredVitalsCoded;
  model n_meds = n_surgeries /dist=zinb;
  zeromodel n_surgeries;
run;






