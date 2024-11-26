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

data mylib.ex1;
   length id 8;
   call streaminit(12345);
   do id=1 to 1000000;
      x1 = rand("Uniform");
      x2 = rand("Uniform") * 10;
      output;
   end;
run;

proc binning data=mylib.ex1 numbin=10 method=quantile;
   input x1-x2;
   output out=mylib.out1;
run;

