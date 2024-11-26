/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_ex3                                         */
/*   TITLE: Example 3 for PROC BINNING                          */
/*    DESC: Bucket Binning and Weight-of-Evidence Computation   */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BINNING                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mylib.ex3;
   input cl1 $ x0  x1  x2  y $ freq id;
   datalines;
a  2  .  7  n  2  1
a  2  2  6  .  3  2
a  3  0  1  o  0  3
c  2  3  7  y  .  4
c  2  .  4  n  -5 5
a  3  6  7  n  3  6
b  1  4  4  y  4  7
b  2  5  6  y  3  8
b  1  6  4  o  1  9
b  2  3  2  n  3  10
;

proc binning data=mylib.ex3 numbin=5 woe;
   input x1/numbin=4;
   input x2;
   target y/event="y";
   output out=mylib.out3;
run;

