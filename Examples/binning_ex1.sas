/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_ex1                                         */
/*   TITLE: Example 1 for PROC BINNING                          */
/*    DESC: Quantile Binning                                    */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BINNING                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mycas.ex1;
   length id 8;
   do id=1 to 1000000;
      x1 = ranuni(101);
      x2 = 10*ranuni(201);
      output;
   end;
run;

proc binning data=mycas.ex1 numbin=10 method=quantile;
   input x1-x2;
   output out=mycas.out1;
run;

