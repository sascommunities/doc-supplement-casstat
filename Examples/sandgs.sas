/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SANDGS                                              */
/*   TITLE: Getting Started Example for PROC SANDWICH           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: SANDWICH                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/


%let nDeductibleInd=5;
%let nDeductibleFam=5;
%let nOutOfPocketInd=6;
%let nOutOfPocketFam=6;
%let nFamSize=5;

data mylib.insure;
   call streaminit(1234);
   do Individual = 1 to 20000;
      rInd = 5 *rand("normal");
      Income = 3 + 2 *rand("normal");
      FamilySize = ceil(&nFamSize * rand("uniform"));
      do Year = 1 to 4;
         DeductibleInd = ceil(&nDeductibleInd * rand("uniform"));
         DeductibleFam = ceil(&nDeductibleFam * rand("uniform"));
         OutOfPocketInd= ceil(&nOutOfPocketInd * rand("uniform"));
         OutOfPocketFam= ceil(&nOutOfPocketFam * rand("uniform"));
         err   = 2*rand("normal");
         spend = 350 + Year + rInd + 3.2*Income + FamilySize +
                 DeductibleInd + DeductibleFam + OutOfPocketInd + OutOfPocketFam + err;
         output;
      end;
   end;
run;

ods select ModelInfo Dimensions ModelAnova;
proc sandwich data=mylib.insure sparse;
   class individual year familysize DeductibleInd DeductibleFam
         OutOfPocketInd OutOfPocketFam;
   clusters individual;
   model spend =  Year Income|DeductibleInd|OutOfPocketInd
                  Income|FamilySize|OutOfPocketFam|DeductibleFam/ss3;
run;

