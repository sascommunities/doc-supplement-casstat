/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_ex2                                         */
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

data mylib.ex2;
   length id 8;
   call streaminit(12345);
   do id=1 to 10000;
      x1 = rand("Uniform");
      x2 = rand("Uniform") * 10;
      x3 = rand("Uniform") * 100;
      output;
   end;
run;

proc binning data=mylib.ex2 numbin=10 method=winsor(rate=0.05);
   input x1-x3;
   output out=mylib.out2;
run;

