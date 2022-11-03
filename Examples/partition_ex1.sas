/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: partition_ex1                                       */
/*   TITLE: Simple Random Sampling                              */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: PARTITION                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC: Example -- Simple Random Sampling                   */
/****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
run;

proc partition data=mycas.hmeq samppct=10 seed=10 nthreads=1;
   output out=mycas.out2 copyvars=(job reason loan value delinq derog);
   display 'SRSFreq';
run;

proc print data=mycas.out2(obs=20);
run;

