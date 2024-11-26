/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: binning_ex5                                         */
/*   TITLE: Example 5 for PROC BINNING                          */
/*    DESC: Tree-based Binning                                  */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BINNING                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mylib.hmeq;
    set sampsio.hmeq;
run;

proc binning data=mylib.hmeq method=tree;
 target bad/level=int;
 input mortdue/level = int;
 input job/ level = nom;
 output outlevelbinmap=mylib.outlevel;
run;

proc print data=mylib.outlevel;
run;

