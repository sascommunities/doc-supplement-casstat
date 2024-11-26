/***************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                */
/*                                                             */
/*    NAME: kclus_ex3.sas                                      */
/*   TITLE: Example 3 for PROC KCLUS                           */
/* PRODUCT: AACAS                                              */
/*  SYSTEM: ALL                                                */
/*    KEYS:                                                    */
/*   PROCS: KCLUS                                              */
/*    DATA:                                                    */
/*                                                             */
/*     REF:                                                    */
/*    MISC:                                                    */
/*                                                             */
/***************************************************************/

data mylib.baseball;
  Set sashelp.baseball;
  Keep Team League Division Position Div;
Run;


proc kclus data=mylib.baseball maxiter=10 maxc=5 DISTANCENOM=RELATIVEFREQ
   outstat(outiter)=mylib.kclusOutstat2;
input Team League Division Position Div / level=nominal;
score out=mylib.kclusOut2 copyvars=(Team League Division Position Div);
ods output FreqNom=FreqNom1;
run;

proc print noobs data=FreqNom1(obs=12);
run;

