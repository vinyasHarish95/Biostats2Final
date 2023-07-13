/* Final - Multivariate Zero-Inflated Negative Binomial Script */;
/* By:  VH    Date Modified: May 8 20*/;

libname final "/folders/myfolders/Biostats2/Final";
run;

/* Check for multicollinearity */
proc reg data=final.rxPredCleaned plots=none;
	model n_meds = sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint n_complaints
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries
						/ tol vif;
run;
'''No tolerance <0.25 and no VIF > 4, so no variables to drop''';

/* Omnibus Liklihood Ratio Test*/
proc genmod data = final.rxPredCleaned;
  class  / param = ref;
  model n_meds =  /dist=zinb;
  zeromodel ;
run;
'''
LL of empty model: -195638.4653
''';

proc genmod data = final.rxPredCleaned;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=zinb;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
run;
'''
LL of full model: -181803.4447

chisq = -2*(LL_empty - LL_full) = 27670
DF = 58
P < 0.00001
Reject null hypothesis.
We know at least one variable is significant as a predictor.
''';


/*Verifying Assumption 1 - Equal Exposure*/;
''' Outcome not a rate, no offset needed. ''';

/*Verifying Assumption 2 - Adequate Fit (Dispersion)*/;
proc genmod data = final.rxPredCleaned;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=zip;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
run;
'''
ODF: 1.4371
''';

proc genmod data = final.rxPredCleaned;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=zinb scale=0 noscale;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
run;
'''
Overdispersion test (lagrange multiplier) chi-sq 15357.4358 p<0.0001
''';

/*Verifying Assumption 3 - Model is Not Overspecified*/;
'''MM: Did not see a Hessian matrix error or other errors; models converged
''';

/*Verifying Assumption 4 - No Influential Outliers*/;
proc genmod data = final.rxPredCleaned plots=leverage;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=zinb link=log;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
run;

'''
 WARNING: Only statistics requested with the following keywords are available for zero-inflated models: PZERO, PRED, RESRAW, RESCHI,
          XBETA, STDXBETA.
''';

proc genmod data = final.rxPredCleaned plots=dfbetas;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=negbin;
run;
'''
Run DFBETAs on a neg bin distribution instead, no outliers observed (>2)
''';

/*Assumption #5 - Independence of Outcomes*/;
'''
 Our outcomes are not independent, there is clustering which we can address as we know there
 are there are three EDs which patients are going to. Will treat this is a nuisance and just
 want to account for this as opposed to understanding the effects of each hospital.
 Thus, will choose to use a marginal model/GEE approach (proc genmod) instead of a mixed model.
''';
/* Full Marginal Model (accounts for clustering based on the hospitals) */
proc genmod data = final.rxPredCleaned;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
  repeated subject=dep_name / type=exch;
run;
'''
Zero inflated distributions not supported... acknowledge as a limitation...
''';


/* Model Validation */;
/* Create a separate data set for each role*/;
data final.Train final.Validate ;
array p[2] _temporary_ (0.5, 0.5);
set final.rxPredCleaned;
call streaminit(123); /* set random number seed */
/* RAND("table") returns 1, 2, or 3 with specified probabilities */
_k = rand("Table", of p[*]);
if      _k = 1 then output final.Train;
else if _k = 2 then output final.Validate;
drop _k;
run;
'''
Obtained from: https://blogs.sas.com/content/iml/2019/01/21/training-validation-test-data-sas.html
''';

proc genmod data = final.Train;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=zinb;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
run;
'''
AIC Train Set: 181551.1810
''';

proc genmod data = final.Validate;
  class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0") maritalstatus (ref="0") insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
  model n_meds = sex age race employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries /dist=zinb;
  zeromodel sex age race lang employstatus maritalstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries;
run;
'''
AIC Val Set: 182417.2928
% difference in AICs:  0.48%
% difference in AICs is less than 5%, model validated.
''';
