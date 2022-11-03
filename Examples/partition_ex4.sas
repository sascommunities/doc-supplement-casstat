/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: partition_ex4                                       */
/*   TITLE: Stratified Sampling                                 */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: PARTITION                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:Example -- Stratified Sampling                       */
/****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
run;

proc partition data=mycas.hmeq kfold=10 seed=10 nthreads=3;
   by BAD;
   output out=mycas.out5 copyvars=(job reason loan value delinq derog);
run;

proc print data=mycas.out5(obs=20);
run;

