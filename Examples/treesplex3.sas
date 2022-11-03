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

data mycas.baseball;
   set sashelp.baseball;
run;

ods graphics on;

proc treesplit data=mycas.baseball maxdepth=3;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB league division nOuts nAssts nError;
   output out=mycas.treesplout;
   prune none;
run;

proc print data=mycas.treesplout(obs=10); run;

