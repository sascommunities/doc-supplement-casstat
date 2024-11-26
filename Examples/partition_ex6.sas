/******************************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                               */
/*                                                                            */
/*   NAME: partition_ex6                                                      */
/*   TITLE: Segment Stratified Sampling for Each Target With Freq Statement   */
/*   PRODUCT: AACAS                                                           */
/*   SYSTEM: ALL                                                              */
/*   KEYS:                                                                    */
/*   PROCS: PARTITION                                                         */
/*   DATA:                                                                    */
/*                                                                            */
/*     REF:                                                                   */
/*    MISC:Example                                                            */
/******************************************************************************/

data mylib.hmeq;
   set sampsio.hmeq;
   id = _N_;
   freqVar = 10;
run;

proc partition data=mylib.hmeq samppct=10 samppct2=20 seed=10;
   by bad;
   target job reason;
   freq freqVar;
   output out=mylib.out6 copyvars=(job reason loan value delinq derog);
run;

proc print data=mylib.out6(obs=20);
run;

