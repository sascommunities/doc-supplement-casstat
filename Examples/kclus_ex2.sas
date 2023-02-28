/***************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                */
/*                                                             */
/*    NAME: kclus_ex2.sas                                      */
/*   TITLE: Example 2 for PROC KCLUS                           */
/* PRODUCT: AACAS                                              */
/*  SYSTEM: ALL                                                */
/*    KEYS:                                                    */
/*   PROCS: KCLUS                                              */
/*    DATA:                                                    */
/*                                                             */
/* SUPPORT:                                                    */
/*     REF:                                                    */
/*    MISC:                                                    */
/*                                                             */
/***************************************************************/

data mycas.iris;
   set sashelp.iris;
run;

proc kclus data=mycas.iris maxclusters=9 seed=1234
           NOC=ABC(B=10 minclusters=2 align=PCA criterion=FIRSTPEAK);
   input SepalLength SepalWidth PetalLength PetalWidth;
   ods output ABCStats=ABCStats1;
run;

