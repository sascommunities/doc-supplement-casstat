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

data mycas.hmeq;
   set sampsio.hmeq;
   id = _N_;
   freqVar = 10;
run;

proc partition data=mycas.hmeq samppct=10 samppct2=20 seed=10;
   by bad;
   target job reason;
   freq freqVar;
   output out=mycas.out6 copyvars=(job reason loan value delinq derog);
run;

proc print data=mycas.out6(obs=20);
run;

