/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: caeffectRegAdjEx1                                   */
/*   TITLE: Example 2 for PROC CAEFFECT                         */
/*    DESC: Estimation by regression adjustment                 */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CAEFFECT, REGADJ                                    */
/*   PROCS: CAEFFECT                                            */
/*    DATA: BirthWgt                                            */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data mycas.birthwgt;
   set sashelp.birthwgt;
run;

proc gradboost data=mycas.birthwgt ntrees=100 seed=8959;
   target Death / level=nominal;
   input  Smoking AgeGroup Married Drinking
          SomeCollege /level=nominal;
   savestate rstore=mycas.gbOutMod;
run;

proc caeffect data=mycas.birthwgt;
   treatvar Smoking;
   outcomevar Death( event='Yes') / type=Categorical;
   outcomemodel restore=mycas.gbOutMod predname=P_DeathYes;
   pom treatlev='Yes';
   pom treatlev='No';
run;

data mycas.gbPredData;
   set mycas.birthwgt;
   tempSmoking = Smoking;
   Smoking = 'Yes';
run;

proc astore;
   score data=mycas.gbPredData out=mycas.gbPredData
         rstore=mycas.gbOutMod
         copyvars=(tempSmoking AgeGroup Married
                   Drinking SomeCollege Death);
run;

data mycas.gbPredData;
   set mycas.gbPredData;
   rename P_DeathYes = SmokingPred;
   Smoking = 'No';
run;

proc astore;
   score data=mycas.gbPredData out=mycas.gbPredData
         rstore=mycas.gbOutMod
         copyvars=(tempSmoking SmokingPred Death);
run;

data mycas.gbPredData;
   set mycas.gbPredData;
   rename P_DeathYes = NoSmokingPred tempSmoking=Smoking;
run;

proc caeffect data=mycas.gbPredData;
   treatvar Smoking;
   outcomevar Death( event='Yes') / type=Categorical;
   pom treatlev='Yes' predOut=SmokingPred;
   pom treatlev='No'  predOut=NoSmokingPred;
run;

