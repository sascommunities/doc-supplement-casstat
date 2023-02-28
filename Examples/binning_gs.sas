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
   call streaminit(12345);
   do id=1 to 1000;
      x1 = rand("Uniform");
      x2 = rand("Uniform") * 10;
      x3 = rand("Uniform") * 100;
      output;
   end;
run;

proc binning data=mycas.bucket numbin=10 method=bucket;
   input x1-x3;
   output out=mycas.out;
run;

