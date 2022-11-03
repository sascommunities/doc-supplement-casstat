/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_e2                                          */
/*   TITLE: Example 2 for PROC BINNING                          */
/*    DESC: Winsorized Binning                                  */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BINNING                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mycas.ex2;
   length id 8;
   do id=1 to 10000;
      x1 = ranuni(101);
      x2 = 10*ranuni(201);
      x3 = 100*ranuni(301);
      output;
   end;
run;

proc binning data=mycas.ex2 numbin=10 method=winsor(rate=0.05);
   input x1-x3;
   output out=mycas.out2;
run;

