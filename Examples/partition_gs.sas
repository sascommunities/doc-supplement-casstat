/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: partition_gs                                        */
/*   TITLE: Getting Started Example for PROC PARTITION          */
/*    DESC: Stratified Patition                                 */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Stratified partitioning                             */
/*   PROCS: PARTITION                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC: Example from the Getting Started section of the     */
/*          PARTITION                                           */
/****************************************************************/

data mylib.hmeq;
   set sampsio.hmeq;
run;

proc partition data=mylib.hmeq samppct=10 samppct2=20 seed=1234 partind;
   by BAD;
   output out=mylib.out1 copyvars=(BAD loan derog mortdue value yoj
          delinq clage ninq clno debtinc);
run;

