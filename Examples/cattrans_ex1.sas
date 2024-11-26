/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cattrans_ex1                                        */
/*   TITLE: Example 1 Home Equity Loan                          */
/* PRODUCT: CASSTAT                                             */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: CATTRANSFORM                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mylib.hmeq;
   set sampsio.hmeq;
run;

proc cattransform data=mylib.hmeq binmissing;
    input reason job derog delinq ninq;
    output out=mylib.score;
run;

