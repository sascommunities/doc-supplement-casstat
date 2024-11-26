
data mylib.baseball;
  set sashelp.baseball;
run;

proc superlearner data=mylib.baseball seed=24893;
   target logSalary / level=interval;
   input nAtBat nHits nHome nRuns nRBI nBB
         yrMajor crAtBat crHits crHome
         crRuns crRbi crBB nOuts nAssts nError
         / level=interval;
   input league division / level=nominal;
   baselearner 'lm' regselect;
   baselearner 'dtree' treesplit;
   baselearner 'bart' bart;
   crossvalidation kfold=6;
   output out=mylib.predout copyvar=logSalary;
run;

proc print data=mylib.predout(obs=10);
run;

