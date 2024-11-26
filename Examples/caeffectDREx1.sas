/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: caeffectDREx1                                       */
/*   TITLE: Example 3 for PROC CAEFFECT                         */
/*    DESC: Doubly robust estimation                            */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CAEFFECT, AIPW, TMLE                                */
/*   PROCS: CAEFFECT                                            */
/*    DATA: SmokingWeight                                       */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

proc logselect data=mylib.SmokingWeight;
   class Sex Race Education Exercise Activity;
   model Quit(Event='1') = Sex Race Education
         Exercise Activity Age YearsSmoke PerDay;
   output out=mylib.swDREstData pred=pTrt copyvars=(_ALL_);
run;

data mylib.swDREstData;
   set mylib.swDREstData;
   pCnt = 1 - pTrt;
run;

proc bart data=mylib.swDREstData nTree=100 nMC=200 seed=2156;
   class Sex Race Education Exercise Activity Quit;
   model Change = Sex Race Education Exercise Quit Activity
         Age YearsSmoke PerDay;
   store out=mylib.bartOutMod;
run;

proc caeffect data=mylib.swDREstData method=aipw;
   treatvar Quit;
   outcomevar Change;
   outcomemodel restore=mylib.bartOutMod predName=P_Change;
   pom treatLev=1 treatProb=pTrt;
   pom treatLev=0 treatProb=pCnt;
   difference evtLev=1;
run;

proc caeffect data=mylib.swDREstData method=tmle;
   treatvar Quit;
   outcomevar Change;
   outcomemodel restore=mylib.bartOutMod predName=P_Change;
   pom treatLev=1 treatProb=pTrt;
   pom treatLev=0 treatProb=pCnt;
   difference evtLev=1;
run;

