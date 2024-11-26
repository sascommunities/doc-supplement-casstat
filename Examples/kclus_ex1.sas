/***************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                */
/*                                                             */
/*    NAME: kclus_ex1.sas                                      */
/*   TITLE: Example 1 for PROC KCLUS                           */
/* PRODUCT: AACAS                                              */
/*  SYSTEM: ALL                                                */
/*    KEYS:                                                    */
/*   PROCS: KCLUS                                              */
/*    DATA:                                                    */
/*                                                             */
/*     REF:                                                    */
/*    MISC:                                                    */
/*                                                             */
/***************************************************************/

data mylib.iris;
   set sashelp.iris;
run;

proc kclus
   data=mylib.iris
   seed=12345
   maxclusters=3
   outstat(outiter)=mylib.kclusOutstat1;
   input SepalLength SepalWidth PetalLength PetalWidth;
   score out=mylib.kclusOut1
   copyvars=(SepalLength SepalWidth PetalLength PetalWidth Species);
run;


proc print noobs data=mylib.kclusOut1(obs=10);
run;

proc print noobs data=mylib.kclusOutstat1(firstobs=1 obs=3);
run;

proc print noobs data=mylib.kclusOutstat1(firstobs=16 obs=18);
run;

