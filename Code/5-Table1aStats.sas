/* Final - Table 1 Script */;
/* By:  VH    Date Modified: May 7 20*/;

'''
Import data
'''

proc import datafile = '/folders/myfolders/Biostats2/Final/dispPred.csv'
 out = dispPred
 dbms = CSV
 replace;
run;

libname final "/folders/myfolders/Biostats2/Final";

proc copy in=work out=final;
select dispPred;
run;quit;

proc print data=myfolder.dispPred;
run;

'''
Drop missing triages variables
''';
data final.dispPred;
	set final.dispPred;
	where (triage_vital_HR ne .) AND (triage_vital_SBP ne .) AND (triage_vital_DBP ne .) AND(triage_vital_RR ne .) AND (triage_vital_O2 ne .) AND (triage_vital_Temp ne .);
run;

'''
Statistical tests
''';

/*Demographics*/;
proc freq data = final.dispPred;
	tables gender * disposition / chisq relrisk;	
run;

proc npar1way data = final.dispPred wilcoxon;
	class disposition;
	var age;
run;

proc freq data = final.dispPred;
	tables race * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables lang * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables maritalstatus * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables employstatus * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables insurance_status * disposition / chisq relrisk;	
run;

/*Triage*/
proc freq data = final.dispPred;
	tables dep_name * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables arrivalmode * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables arrivalday * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables arrivaltime * disposition / chisq relrisk;	
run;

'''
The triage vitals are reading as char, cast into numerics
''';

data final.dispPredVitalsCoded;
   set final.dispPred;                                                                                                                                                                                                                                       
   triage_vital_HR_n=input(triage_vital_HR, 4.);
   triage_vital_SBP_n=input(triage_vital_SBP, 4.);
   triage_vital_DBP_n=input(triage_vital_DBP, 4.);
   triage_vital_RR_n=input(triage_vital_RR, 4.);
   triage_vital_O2_n=input(triage_vital_O2, 4.);
   triage_vital_Temp_n=input(triage_vital_Temp, 4.);
run;

proc npar1way data = final.dispPredVitalsCoded wilcoxon;
	class disposition;
	var triage_vital_HR_n;
run;

proc npar1way data = final.dispPredVitalsCoded wilcoxon;
	class disposition;
	var triage_vital_SBP_n;
run;

proc npar1way data = final.dispPredVitalsCoded wilcoxon;
	class disposition;
	var triage_vital_DBP_n;
run;

proc npar1way data = final.dispPredVitalsCoded wilcoxon;
	class disposition;
	var triage_vital_RR_n;
run;

proc npar1way data = final.dispPredVitalsCoded wilcoxon;
	class disposition;
	var triage_vital_O2_n;
run;

proc npar1way data = final.dispPredVitalsCoded wilcoxon;
	class disposition;
	var triage_vital_Temp_n;
run;

proc freq data = final.dispPred;
	tables esi * disposition / chisq relrisk;	
run;

proc freq data = final.dispPred;
	tables chief_complaint * disposition / chisq relrisk;	
run;

proc npar1way data = final.dispPred wilcoxon;
	class disposition;
	var n_complaints;
run;

/*Healthcare Usage*/
proc freq data = final.dispPred;
	tables previousdispo * disposition / chisq relrisk;	
run;

proc npar1way data = final.dispPred wilcoxon;
	class disposition;
	var n_edvisits;
run;

proc npar1way data = final.dispPred wilcoxon;
	class disposition;
	var n_admissions;
run;

proc npar1way data = final.dispPred wilcoxon;
	class disposition;
	var n_surgeries;
run;

'''
Calculate Standardized Differences
''';

data final.dispPredVitalsCodedOutcomeCoded;
set final.dispPredVitalsCoded;
dispNum = .;
if (disposition = 'Admit') then dispNum = 1;
if (disposition = 'Discharge') then dispNum = 0;
run; 

%include '/folders/myfolders/Biostats2/Final/stddiff.sas'; 

/*Demographics*/;
%stddiff(inds =final.dispPredVitalsCodedOutcomeCoded,
          groupvar = dispNum,
          charvars = insurance_status,
          stdfmt = 5.2,
          outds = std_result);
    
/*Triaging Information*/
%stddiff(inds =final.dispPredVitalsCodedOutcomeCoded,
          groupvar = dispNum,
          numvars = n_complaints,
          stdfmt = 5.2,
          outds = std_result);

/*Healthcare Usage*/;
%stddiff(inds =final.dispPredVitalsCodedOutcomeCoded,
          groupvar = dispNum,
          numvars = n_edVisits n_admissions n_surgeries,
          charvars = previousdispo,
          stdfmt = 5.2,
          outds = std_result); 

