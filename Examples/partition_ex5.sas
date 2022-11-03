/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: partition_ex5                                       */
/*   TITLE: Segment Stratified Sampling for Each Target         */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: PARTITION                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:Example --Segment Stratified Sampling for Each Target*/
/****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
run;

proc partition data=mycas.hmeq samppct=10 samppct2=20 seed=10 nthreads=3;
   by bad;
   target job reason;
   output out=mycas.out3 copyvars=(job reason loan value delinq derog);
run;

proc print data=mycas.out3(obs=20);
run;

