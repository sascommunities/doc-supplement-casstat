/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX5                                              */
/*   TITLE: Documentation Example 6 for PROC SPC                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Producing Control Charts with PROC SHEWHART         */
/*   PROCS: SPC                                                 */
/*    DATA:                                                     */
/*     REF: PROC SPC, Example 5                                 */
/*                                                              */
/****************************************************************/

proc shewhart table=mycas.RandomTests(where=(_VAR_ eq 'Process047'));
   xchart Process047 * Subgroup /
            tests = 1 to 4
            markers;
run;

