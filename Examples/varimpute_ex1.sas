/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: varimpute_ex1                                       */
/*   TITLE: Example 1 for PROC VARIMPUTE                        */
/*    DESC: Imputation of Missing Values for HMEQ Data Table    */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: VARIMPUTE                                           */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/****************************************************************/

data mycas.hmeq;
   set sampsio.hmeq;
   id = _N_;
run;

proc varimpute data=mycas.hmeq seed=12345;
   input derog clno/ctech=value cvalues=5,20;
   input value /ctech=mean;
   input job/ntech=mode;
   input mortdue /ctech=median;
   input ninq /ctech=random;
   input reason/ntech=value valuescharacter=unknown;
   output out=mycas.out1 copyvar=(id);
run;

data out2; set mycas.out1; run;
proc sort data=out2; by id; run;
proc print data=out2(firstobs=110 obs=124);
run;

