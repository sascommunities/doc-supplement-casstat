/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: phex2                                              */
/*   TITLE: Example 2 for PROC PHSELECT                         */
/*   DESC:  Stratified Analysis                                 */
/* PRODUCT: VIYASTAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: stratified analysis,                                */
/*          SAS scoring code,                                   */
/*          direct adjusted survival                            */
/*   PROCS: PHSELECT                                            */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

proc phselect data=mycas.getStarted;
   class C1 C2;
   model Time*Status(0) = C1 C2 X1-X4;
   strata C3;
   code file='ScoreCode.txt' showtime;
run;

data Scores;
   set mycas.getStarted;
   %inc 'ScoreCode.txt';
run;

proc print data=Scores (obs=1);
   var Time_:;
run;

proc means data=Scores mean;
   class C3;
   var S_Time_:;
run;

