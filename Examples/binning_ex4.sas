/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_ex4                                         */
/*   TITLE: Example 4 for PROC BINNING                          */
/*    DESC: Cutpoint Binning                                    */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BINNING                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mycas.ex4;
   input cl1 $ cl2  x1  x2  y  freq id;
   datalines;
a     2    3   7  9   2   1
a     2    2   6  8   3   2
a     3    0   1  5   0   3
c     2    3   7  4   .   4
c     2    .   4  8   -5  5
a     3    6   7  5   3   6
b     1    4   4  8   4   7
b     2    5   6  3   3   8
b     1    6   4  8   1   9
b     2    3   2  6   3   10
;

proc binning data=mycas.ex4 numbin=4 method=cutpts;
   input x2/cutpts(2, 2.3, 4.5);
   input x1/numbin=3 cutpts(3.1, 5);
run;

