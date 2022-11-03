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

proc spc data=mycas.AllProcesses;
   xrchart / noprint
             outtable  = mycas.AllTable
             outlimits = mycas.AllLimits;
run;

proc print data=mycas.AllTable(obs=10) noobs;
run;

proc print data=mycas.AllLimits noobs;
run;

