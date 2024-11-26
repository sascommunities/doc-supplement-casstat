/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREESPLEX3                                          */
/*   TITLE: Documentation Example 3 for PROC TREESPLIT          */
/*                                                              */
/* PRODUCT: VIYASTAT                                            */
/*  SYSTEM:                                                     */
/*    KEYS:                                                     */
/*   PROCS: TREESPLIT                                           */
/*                                                              */
/****************************************************************/

data mylib.baseball;
   set sashelp.baseball;
run;

ods graphics on;

proc treesplit data=mylib.baseball maxdepth=3;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB league division nOuts nAssts nError;
   output out=mylib.treesplout;
   prune none;
run;

proc print data=mylib.treesplout(obs=10); run;

