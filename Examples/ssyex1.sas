/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SSYEX1                                              */
/*   TITLE: Example 1 for PROC SIMSYSTEM                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation                                          */
/*   PROCS: SIMSYSTEM UNIVARIATE                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMSYSTEM, EXAMPLE 1.                          */
/*    MISC:                                                     */
/****************************************************************/

/*
/ Generate nonnormal data with specified moments.
/---------------------------------------------------------------------*/

proc simsystem system=Johnson n=10000 seed=12345;
   moments mean=5 stddev=2 skew=1 kurt=4.5;
   output out=mycas.SB;
run;

/*
/ Use UNIVARIATE to fit in SB distribution.
/---------------------------------------------------------------------*/

proc univariate data=mycas.SB;
   var variate;
   histogram / sb(theta=est sigma=est fitmethod=moments) noplot;
run;

/*
/ Generate 10,000 replicate samples and use PROC KDE to plot the
/ distribution of skewness and kurtosis values.
/---------------------------------------------------------------------*/

ods select none;
proc simsystem system=johnson n=10000 seed=12345 nrep=10000 momentreps;
   moments mean=5 stddev=2 skew=1 kurt=4.5;
   ods output Moments=Moments;
run;
ods select all;

proc kde data=Moments;
   bivar SampleSkewness SampleKurtosis / plots=contour;
run;

