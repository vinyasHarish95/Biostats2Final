/* Final - Univariate Logistic Regression Script */;
/* By:  VH    Date Modified: May 7 20*/;

libname final "/folders/myfolders/Biostats2/Final";
run;

/*Primary Predictor*/
proc logistic data = final.dispPred plots=roc;
	class esi(ref='3');
	model disposition= esi;
run;

/*Demographics*/
proc logistic data = final.dispPred plots=roc;
	class gender(ref='Male');
	model disposition= gender;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= age;
run;

proc logistic data = final.dispPred plots=roc;
	class race(ref='White or Caucasian');
	model disposition= race;
run;

proc logistic data = final.dispPred plots=roc;
	class lang(ref='English');
	model disposition= lang;
run;

proc logistic data = final.dispPred plots=roc;
	class employstatus(ref='Full Time');
	model disposition= employstatus;
run;

proc logistic data = final.dispPred plots=roc;
	class insurance_status (ref='Commercial');
	model disposition= insurance_status;
run;


/* Triage */
proc logistic data = final.dispPred plots=roc;
	class dep_name(ref='Freestanding ER');
	model disposition= dep_name;
run;

proc logistic data = final.dispPred plots=roc;
	class arrivalmode(ref='Walk-in');
	model disposition= arrivalmode;
run;

proc logistic data = final.dispPred plots=roc;
	class arrivaltime(ref='Day');
	model disposition= arrivaltime;
run;

proc logistic data = final.dispPred plots=roc;
	class arrivalday(ref='Weekday');
	model disposition= arrivalday;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= triage_vital_HR;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= triage_vital_SBP;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= triage_vital_DBP;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= triage_vital_RR;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= triage_vital_O2;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= triage_vital_temp;
run;

proc logistic data = final.dispPred plots=roc;
	class chief_complaint(ref='cc_other');
	model disposition= chief_complaint;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= n_complaints;
run;

/*Healthcare Usage*/
proc logistic data = final.dispPred plots=roc;
	class previousdispo(ref='No previous disposition');
	model disposition= previousdispo;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= n_edvisits;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= n_admissions;
run;

proc logistic data = final.dispPred plots=roc;
	model disposition= n_surgeries;
run;
