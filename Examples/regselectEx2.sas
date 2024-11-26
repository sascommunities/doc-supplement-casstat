/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regselectEx2                                        */
/*   TITLE: Getting Started Example for PROC REGSELECT          */
/*    DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                   */
/*     REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*          Update, Macmillan Publishing Company, New York.     */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection                                     */
/*   PROCS: REGSELECT                                           */
/*                                                              */
/****************************************************************/

   data mylib.baseball;
      set sashelp.baseball;
   run;

ods graphics on;
proc regselect data=mylib.baseball;
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(choose=validate) plots=all;
run;

proc regselect data=mylib.baseball;
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(adaptive choose=validate);
run;

proc regselect data=mylib.baseball;
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(lscoeffs choose=validate);
run;

ods path work.templat(update) sashelp.tmplmst(read);
proc template;
   edit ACAS.REGSELECT.RelaxedLassoSummary;
   edit  ValidationASE;  format=best8.; end;
end;
run;

proc regselect data=mylib.baseball;
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(relaxed choose=validate);
run;

proc regselect data=mylib.baseball;
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(relaxed(kappa=0.05 to 0.15  by 0.001) choose=validate);
run;

proc regselect data=mylib.baseball;
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(relaxed(kappa=0.05 to 0.15  by 0.001) choose=validate);
   ods output Summary.RelaxedLassoSummary=ex2_RLSummary_fine
              FitStatistics = ex2_RLFitStatistics_fine
              ParameterEstimates = ex2_RLPE_fine;
run;
data _null_;
   set work.ex2_RLSummary_fine;
   if _n_ le 6  or 66 le _n_ le 73 or _n_ ge 99;
   if 4 le _n_ le 6 then do;
   Step = .; Kappa = .; nEffectsIn = .; ValidationASE=.; end;
   if 71 le _n_ le 73 then do;
   Step = .; Kappa = .; nEffectsIn = .; ValidationASE=.; end;
   file print ods = (template = 'ACAS.REGSELECT.RelaxedLassoSummary');
   put _ods_;
run;
title "Model Selected by Relaxed LASSO";
data _null_;
   set work.ex2_RLFitStatistics_fine;
       file print ods = (template = 'ACAS.REGSELECT.FitStatistics');
   put _ods_;
run;
title;
data _null_;
   set work.ex2_RLPE_fine;
       file print ods = (template = 'ACAS.REGSELECT.ParameterEstimates');
   put _ods_;
run;

proc regselect data = mylib.baseball(where=(Position='C'));
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = lasso(choose=validate);
run;

proc regselect data=mylib.baseball(where=(Position='C'));
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = elasticnet(choose=validate);
   ods output ElasticNetSummary=ElasticNetSummary;
run;

proc regselect data=mylib.baseball(where=(Position='C'));
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = elasticnet(adaptive choose=validate);
run;

proc regselect data=mylib.baseball(where=(Position='C'));
   partition roleVar = league(train='National' validate = 'American');
   class division;
   model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB nOuts nAssts nError;
   selection method = elasticnet(adaptive choose=validate);
   ods output Summary.ElasticNetSummary=ex2_ENSummary_adaptive
              FitStatistics = ex2_ENFitStatistics_adaptive
              ParameterEstimates = ex2_ENPE_adaptive;
run;
data _null_;
   set work.ex2_ENSummary_adaptive;
   if _n_ le 6  or 37 le _n_ le 46 or _n_ ge 48;
   if 4 le _n_ le 6 then do;
   Step = 3; L2 = .; nEffectsIn = .; ValidationASE=.; end;
   if 44 le _n_ le 46 then do;
   Step = 43; L2 = .; nEffectsIn = .; ValidationASE=.; end;
   file print ods = (template = 'ACAS.REGSELECT.ElasticNetSummary');
   put _ods_;
run;
title "Selected Model by Adaptive Elastic Net";
data _null_;
   set work.ex2_ENFitStatistics_adaptive;
   file print ods = (template = 'ACAS.REGSELECT.FitStatistics');
   put _ods_;
run;
title;
data _null_;
       set work.ex2_ENPE_adaptive;
       file print ods = (template = 'ACAS.REGSELECT.ParameterEstimates');
   put _ods_;
run;

