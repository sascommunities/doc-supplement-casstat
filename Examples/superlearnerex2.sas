
proc superlearner data=mylib.SmokingWeight seed=2324;
   target Quit / level=nominal;
   input Sex Race Education Exercise Activity / level=nominal;
   input Age YearsSmoke PerDay / level=interval;
   baselearner 'logistic' logselect;
   baselearner 'logistic_2way' logselect
      class=(Sex Race Education Exercise Activity)
      effect=(Age|YearsSmoke|PerDay|Sex|Race|Education|Exercise|Activity @ 2);
   baselearner 'logistic_ridge' logselect(selection=ELASTICNET(lambda=5 mixing=0))
      class=(Sex Race Education Exercise Activity)
      effect=(Age|YearsSmoke|PerDay|Sex|Race|Education|Exercise|Activity @ 2);
   baselearner 'gam' gammod;
   baselearner 'bart' bart(nTree=10 nMC=100);
   output out=mylib.swTrtEstData copyvars=(_ALL_);
run;

data mylib.swTrtEstData;
  set mylib.swTrtEstData;
  P_Quit1 = 1 - P_Quit0;
run;

proc superlearner data=mylib.swTrtEstData seed=2324;
   baselearner 'linear' regselect;
   baselearner 'linear_2way' regselect
      class=(Sex Race Education Exercise Activity Quit)
      effect=(Age|YearsSmoke|PerDay|Sex|Race|Education|Exercise|Activity|Quit @ 2);
   baselearner 'linear_ridge' regselect(selection=ELASTICNET(lambda=5 mixing=0))
      class=(Sex Race Education Exercise Activity Quit)
      effect=(Age|YearsSmoke|PerDay|Sex|Race|Education|Exercise|Activity|Quit @ 2);
   baselearner 'gam' gammod;
   baselearner 'bart' bart(nTree=10 nMC=100);
   margin 'quitsmoking' Quit=1;
   margin 'noquitsmoking' Quit=0;
   target Change / level=interval;
   input Sex Race Education Exercise Activity Quit / level=nominal;
   input Age YearsSmoke PerDay / level=interval;
   output out=mylib.swDREstData marginpred copyvars=(Quit Change P_Quit1 P_Quit0);
run;

proc caeffect data=mylib.swDREstData inference method=TMLE;
   treatvar Quit;
   outcomevar Change;
   pom treatLev=1 treatProb=P_Quit1 predout=quitsmoking;
   pom treatLev=0 treatProb=P_Quit0 predout=noquitsmoking;
   difference evtLev=1;
run;

