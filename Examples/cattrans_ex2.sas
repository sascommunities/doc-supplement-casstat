/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cattrans_ex2                                        */
/*   TITLE: Example 2 Classification Tree Binning               */
/* PRODUCT: CASSTAT                                             */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: CATTRANSFORM                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
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

proc cattransform data=mylib.catdata evaluationstats;
    input c1 c2;
    target y / level=nominal event='1';
    method tree;
    output out=mylib.score;
    savestate rstore=mylib.classmodel;
run;

