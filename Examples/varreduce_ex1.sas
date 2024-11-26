/********************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                     */
/*                                                                  */
/*    NAME: varreduce_ex1.sas                                       */
/*   TITLE: Example 1 for PROC VARREDUCE                            */
/*                                                                  */
/* PRODUCT: AACAS                                                   */
/*  SYSTEM: ALL                                                     */
/*    KEYS:                                                         */
/*   PROCS: VARREDUCE                                               */
/*    DATA:                                                         */
/*                                                                  */
/*     REF:                                                         */
/*    MISC:                                                         */
/********************************************************************/

data mylib.heart;
   set sashelp.heart;
run;

proc varreduce data=mylib.heart matrix=COV tech=DSC;
   ods output SelectionSummary=Summary;
   class Status Sex Chol_Status BP_Status Weight_Status Smoking_Status;
   reduce supervised Status = Sex AgeAtStart Height Weight Diastolic Systolic MRW
                              Smoking Cholesterol Chol_Status BP_Status Weight_Status
                              Smoking_Status/ maxiter=15 BIC;
   display 'SelectionSummary' 'SelectedEffects';
run;

proc sgplot data=Summary;
   series x=Iteration  y=BIC;
run;

