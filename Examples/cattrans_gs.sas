/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cattrans_gs                                         */
/*   TITLE: Getting Started Example for PROC CATTRANSFORM       */
/* PRODUCT: CASSTAT                                             */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: CATTRANSFORM                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC: Example from the Getting Started section of the     */
/*          CATTRANSFORM                                        */
/****************************************************************/

data mylib.catdata;
    call streaminit(12345);
    do myid=1 to 1000;
        y=rand('table',.1,.9);
        c1=rand('table',.35,.25,.2,.1,.04,.03,.02,.01);
        c2=rand('table',.01,.02,.03,.04,.1,.2,.25,.35);
        output;
    end;
run;

proc cattransform data=mylib.catdata;
    input c1 c2;
    output out=mylib.out;
run;

