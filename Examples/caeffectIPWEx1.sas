/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: caeffectIPWEx1                                      */
/*   TITLE: Example 1 for PROC CAEFFECT                         */
/*    DESC: Estimation by inverse probability weighting         */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CAEFFECT, IPW                                       */
/*   PROCS: CAEFFECT                                            */
/*    DATA: SmokingWeight                                       */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

proc logselect data=mycas.SmokingWeight;
   class Sex Race Education Exercise Activity;
   model Quit = Sex Race Education Exercise
                Activity Age YearsSmoke PerDay;
   store out=mycas.logTrtModel;
run;

proc astore;
   score data=mycas.SmokingWeight out=mycas.logScored
         rstore=mycas.logTrtModel copyvars=(Quit Change);
run;

proc caeffect data=mycas.logScored inference;
   treatvar Quit;
   outcomevar Change;
   pom treatlev = 1 treatProb = P_Quit1;
   pom treatlev = 0 treatProb = P_Quit0;
   difference reflev=0;
run;

proc caeffect data=mycas.logScored;
   treatvar Quit / condevent=1;
   outcomevar Change;
   pom treatlev = 1 treatProb = P_Quit1;
   pom treatlev = 0 treatProb = P_Quit0;
   difference reflev=0;
run;

