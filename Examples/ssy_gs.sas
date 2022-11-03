/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SIMSYS1                                             */
/*   TITLE: Getting Started Example for PROC SIMSYSTEM          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation skewness kurtosis                        */
/*   PROCS: SIMSYSTEM ANOVA                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMSYSTEM, INTRODUCTORY EXAMPLE                */
/*    MISC:                                                     */
/****************************************************************/

/*
/ Generate nonnormal data with skewness 1.5 and kurtosis 7.
/---------------------------------------------------------------------*/

ods graphics on;
proc simsystem system=pearson n=100 seed=12345;
   moments skewness=1.5 kurtosis=7;
   output out=mycas.sim;
run;

/*
/ Perform ANOVA on the resulting sample.
/---------------------------------------------------------------------*/

data mycas.sim; set mycas.sim;
   a = mod(iObs-1,5)+1;
   y = variate;
run;

proc regselect data=mycas.sim;
   class a;
   model y = a;
run;

/*
/ Use PROC SIMSYSTEM with an input data set to generate 1,000 samples
/ of size 100 from the Pearson distribution over multiple skewness
/ and kurtosis pairs.
/---------------------------------------------------------------------*/

proc simsystem system=pearson n=100 seed=12345 nrep=1000;
   moments skewness = 0 0 0.75 0.75 0.75 1.5
           kurtosis = 3 5 3    5    7    7  ;
   output out=mycas.sim;
run;

/*
/ Evaluate how often F test is rejected at the 10%, 5%, and 1% levels.
/---------------------------------------------------------------------*/

data mycas.sim; set mycas.sim;
   a = mod(iObs-1,5)+1;
   y = variate;
run;

ods select none;
proc regselect data=mycas.sim;
   by Skewness Kurtosis Rep;
   class a;
   model y = a;
   displayout ANOVA=AOV;
run;
ods select all;

data mycas.AOV; set mycas.AOV;
   where (Source = "Model");
   Rej10 = (ProbF < 0.10);
   Rej05 = (ProbF < 0.05);
   Rej01 = (ProbF < 0.01);
proc mdsummary data=mycas.AOV;
   groupby Skewness Kurtosis;
   var Rej:;
   output out=mycas.AOV_summary;
proc transpose data=mycas.AOV_summary(rename=(_Column_=_Name_)) out=summary;
   by notsorted Skewness Kurtosis;
   var _Mean_;
proc sort data=summary;
   by Skewness Kurtosis;
proc print data=summary noobs;
   var Skewness Kurtosis Rej01 Rej05 Rej10;
   format Rej01 Rej05 Rej10 5.3;
run;

proc simsystem system=pearson n=100 seed=12345 nrep=1000 plot(only)=mrmap;
   momentgrid skewness = 0 to 1.5 by 0.25
              kurtosis = 3 to 7   by 1;
   output out=mycas.sim;
run;

