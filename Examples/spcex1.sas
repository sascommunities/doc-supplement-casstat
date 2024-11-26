/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX1                                              */
/*   TITLE: Documentation Example 1 for PROC SPC                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Output Data Tables                                  */
/*   PROCS: SPC                                                 */
/*    DATA:                                                     */
/*     REF: PROC SPC, Example 1                                 */
/*                                                              */
/****************************************************************/

proc spc data=mylib.AllProcesses;
   xrchart / noprint
             outtable  = mylib.AllTable
             outlimits = mylib.AllLimits;
run;

proc print data=mylib.AllTable(obs=10) noobs;
run;

proc print data=mylib.AllLimits noobs;
run;

