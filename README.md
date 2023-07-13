# Validating the Emergency Severity Index and Automating Polypharmacy Screening at Triage with 500,000 Electronic Medical Records: A Retrospective Cohort Study

## Abstract
### Objective:
The primary objective of this work was to evaluate the association between the Emergency Severity
Index (ESI) and triage disposition in three emergency departments (EDs) in New Haven, Connecticut.
The secondary objective was to explore if factors commonly ascertained during triage are associated
with polypharmacy in older and middle-aged adults presenting to the ED.

### Methods:
We conducted a retrospective analysis of over 500,000 electronic medical records from adult visits to
three EDs between the years of 2013 and 2017. To determine if an association exists between the ESI
and triage disposition, a multivariable logistic regression model was created using generalized
estimating equations to account for clustering at the ED-level. The fundamental assumptions for
logistic regression were tested. To determine if factors commonly ascertained during triage were
associated with polypharmacy, a multivariable zero-inflated negative binomial regression model was
created. The fundamental assumptions for multivariable zero-inflated negative binomial regression
were tested.

### Results:
ESI-1 (OR 7.15, 95% CI: 6.64-7.69, p<0.01) and ESI-2 (OR 2.21, 95% CI: 2.02-2.42, p<0.01) increased the
odds of being admitted relative to ESI-3. ESI-4 (OR 0.10, 95% CI: 0.07-0.13, p<0.01) and ESI-5 (OR 0.02,
95% CI: 0.01 – 0.04, p<0.01) decreased the odds of being admitted relative to ESI-3. Zero-inflated
negative binomial analyses demonstrated associations between commonly ascertained triage factors,
such as a patient’s chief complaint, race, and insurance status, and the number of medications they
were taking at time of presentation. In terms of discrimination, our novel triaging model outperformed
the ESI in correctly predicting the triage disposition of an ED visit.

### Conclusions:
This work adds to the literature validating the ESI in different settings, but also suggests through
exploratory analyses that an automated triaging algorithm may be able to outperform the ESI in
predicting triage disposition and that several factors commonly ascertained during triage are
associated with polypharmacy.

## Data Citation
This work makes use of EMRs from 560, 486 adult visits to three Yale New Haven Health System (YNHHS) EDs between 2013 and 2017. Data extracted from these EMRs were deidentified, with
no patient key, and are at the level of analysis of the ED visit. Thus, it is possible that a single patient is captured in multiple ED visits in the cohort, but it is not possible to aggregate a single patient’s visits or isolate a patient’s first visit. The cohort captures a level-1 trauma centre, community hospital, and community free-standing ED which are all part of YNHHS, all use the Epic EMR system (Verona, WI, USA), and all triage patients with the ESI. For each patient visit, 972 variables have been extracted from the Epic EMR (e.g. the triage disposition, demographics, triage evaluation variables, chief complaints, etc.). A full list of variables including those used for primary and secondary analyses can be found in the supplemental data dictionary.

Thank you to the authors for making this data available to the research community! 

**Citation:** Hong WS, Haimovich AD, Taylor RA (2018) Predicting hospital admission at emergency department triage using machine learning. PLoS ONE 13(7): e0201016." (https://doi.org/10.1371/journal.pone.0201016)

**GitHub:** https://github.com/yaleemmlc/admissionprediction
