/******************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                   */
/*                                                                */
/*    NAME: varimpute_gs                                          */
/*   TITLE: Getting Started Example for PROC VARIMPUTE            */
/* PRODUCT: AACAS                                                 */
/*  SYSTEM: ALL                                                   */
/*    KEYS:                                                       */
/*   PROCS: VARIMPUTE                                             */
/*    DATA:                                                       */
/*                                                                */
/*     REF:                                                       */
/*    MISC: Example from the Getting Started section of the       */
/*          VARIMPUTE                                             */
/******************************************************************/

data mylib.hmeq;
   set sampsio.hmeq;
run;

proc varimpute data=mylib.hmeq seed=18000;
   input clage /ctech=mean;
   input delinq/ctech=median;
   input ninq/ctech=random;
   input reason/ntech=mode;
   input job/ntech=value valuescharacter=Office;
   input debtinc yoj/ctech=value cvalues=50,100;
   output out=mylib.out;
run;

