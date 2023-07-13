/* Final - Multivariate Logistic Regression Script */;
/* By:  VH    Date Modified: May 8 20*/;

libname final "/folders/myfolders/Biostats2/Final";
run;

/*Assumption #4 - Independence of Outcomes*/;
'''
 Our outcomes are not independent, there is clustering which we can address as we know there
 are there are three EDs which patients are going to. Will treat this is a nuisance and just
 want to account for this as opposed to understanding the effects of each hospital.
 Thus, will choose to use a marginal model/GEE approach (proc genmod) instead of a mixed model.
''';

/*Variable Selection and Validation*/;
'''
 We are investigating an a priori association and thus do not need to do variable selection
 or validation.
''';

/* Check for multicollinearity */
proc reg data=final.dispPredCleaned plots=none;
	model disposition = sex age race lang employstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint n_complaints
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries
						/ tol vif;
run;
'''No tolerance <0.25 and no VIF > 4, so no variables to drop''';

/* Omnibus Test*/
proc logistic data = final.dispPredCleaned plots=roc;
	class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0")  insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
	model disposition(event="1") = sex age race lang employstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint n_complaints
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries / lackfit;
run;
'''
Omnibus liklihood ratio test:
chi-sq=80136.5117 	DF=54 	p <.0001
Reject null hypothesis.
We know at least one variable is significant as a predictor.
Wald tests for almost all variables also significant, except for n_complaints (p=0.4124) and SBP (0.5832)
''';

/* Create marginal model w all variables*/
proc genmod data = final.dispPredCleaned descend;
	class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0")  insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
	model disposition = sex age race lang employstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint n_complaints
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries
						/dist=binomial link=logit;
    repeated subject=dep_name / type=exch;
run;
'''
Not enough computational capacity for unstructured covariance
Correlation: 0.0059751495
''';

/*Verifying Assumption 1 - Model Goodness of Fit (done on naive LR for now) */;
proc logistic data = final.dispPredCleaned plots=roc;
	class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0")  insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3")  chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
	model disposition(event="1") = sex age race lang employstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint n_complaints
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries / lackfit;
run;

'''
AUC: 0.857
HL Test: chisq=9.3706 	DF=8 	p=0.3120
Accept the null hypothesis, fit ok.
AIC: 182299.13
''';

/*Verifying Assumption 2 - Model is Not Overspecified*/;
'''LR: Did not see a warning that there is complete or quasi-complete seperation of data points" or ORs between <0.0001 - 999.9''';
'''MM: Did not see a Hessian matrix error or other errors; models converged''';

/*Verifying Assumption 3 - No Influential Outliers*/;
proc genmod data = final.dispPredCleaned descend plots = dfbetas;
	class sex(ref="0") race (ref="0") lang (ref="0") employstatus (ref="0")  insurance_status (ref="0")
		  dep_name(ref="0")  arrivalmode(ref="0")  arrivaltime(ref="0")  arrivalday(ref="0") esi(ref="3") chief_complaint(ref="0")
		  previousdispo(ref="0") / param = ref;
	model disposition = sex age race lang employstatus insurance_status
						dep_name arrivalmode arrivaltime arrivalday esi chief_complaint n_complaints
						triage_vital_HR triage_vital_SBP triage_vital_DBP triage_vital_RR triage_vital_O2 triage_vital_Temp
						previousdispo n_edvisits n_admissions n_surgeries
						/dist=binomial link=logit;
    repeated subject=dep_name / type=exch;
run;
'''
Exceeds computational capacity to run.
Tried computing DFBETAs, storing them into an output dataset, thresholding > 2 -- still ran out of computational capacity.
''';

/*Extra Analysis w only ESI*/;
proc logistic data = final.dispPredCleaned plots=roc;
	class esi(ref="3") / param = ref;
	model disposition(event="1") = esi/ lackfit;
	output out=final.LogiOut predicted=PredProb;
run;

proc sort data=final.LogiOut;  by PredProb;  run;  /* Then sort */

/* let the data choose the smoothing parameter */
title "Calibration Plot for a Correct Model";
proc sgplot data=final.LogiOut noautolegend aspect=1;
   loess x=PredProb y=disposition / interpolation=cubic clm nomarkers;
   lineparm x=0 y=0 slope=1 / lineattrs=(color=grey pattern=dash);
   yaxis grid; xaxis grid;
run;

proc loess data=final.LogiOut plots=observedbypredicted;
model disposition = PredProb / interp=cubic  ;
run;
'''
From: https://github.com/sascommunities/the-do-loop-blog/blob/master/calibration-plots/CalibrationPlot.sas
AUC: 0.760
HL Test: chisq=0	DF=2 	p=1.0000
AIC: 213740.35
''';
