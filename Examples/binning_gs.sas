/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_gs                                          */
/*   TITLE: Getting Started Example for PROC BINNING            */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BINNING                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC: Example from the Getting Started section of the     */
/*          BINNING                                             */
/****************************************************************/

data mycas.bucket;
   length id 8;
   do id=1 to 1000;
      x1 = ranuni(101);
      x2 = 10*ranuni(201);
      x3 = 100*ranuni(301);
      output;
   end;
run;

proc binning data=mycas.bucket numbin=10 method=bucket;
   input x1-x3;
   output out=mycas.out;
run;

