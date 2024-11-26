/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regselectgs                                         */
/*   TITLE: Getting Started Example for PROC REGSELECT          */
/*    DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                   */
/*     REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*          Update, Macmillan Publishing Company, New York.     */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection                                     */
/*   PROCS: REGSELECT                                           */
/*                                                              */
/****************************************************************/

proc contents varnum data=sashelp.baseball;
   ods select position;
run;

data mylib.baseball;
   set sashelp.baseball;
run;

ods graphics on;

proc regselect data=mylib.baseball;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB league division nOuts nAssts nError;
   selection method=stepwise plots=all;
run;

proc regselect data=mylib.baseball;
  class league division;
  model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                    yrMajor crAtBat crHits crHome crRuns crRbi
                    crBB league division nOuts nAssts nError / vif clb;
  selection method=stepwise;
  output out=mylib.baseballOut
         p=predictedLogSalary r h cookd rstudent copyvars=(name);
run;

proc print data=mylib.baseballOut(obs=5);
run;


