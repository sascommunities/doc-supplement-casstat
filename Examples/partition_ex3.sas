/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: partition_ex3.sas                                   */
/*   TITLE: Oversampling                                        */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: PARTITION                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:Example -- Oversampling                              */
/****************************************************************/

data mylib.hmeq;
   set sampsio.hmeq;
run;

proc partition data=mylib.hmeq samppctevt=90 eventprop=0.5
               event="1" seed=10 nthreads=1;
   by BAD;
   ods output OVERFREQ=outFreq;
   output out=mylib.out4 copyvars=(job loan value delinq derog)
          freqname=_Freq2_;
run;

proc print data=mylib.out4(obs=20);
run;

