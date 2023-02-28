/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regselectEx3                                        */
/*   TITLE: SCAD and MCP Examples for PROC REGSELECT            */
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

   data mycas.baseball;
      set sashelp.baseball;
  run;

   proc regselect data=mycas.baseball;
       partition roleVar = league(train='National' validate = 'American');
       class division;
       model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                      yrMajor crAtBat crHits crHome crRuns crRbi
                      crBB nOuts nAssts nError;
      selection  method = scad(choose=validate) details=all;
      ods output ModelInfo = ex3scadModelInfo
          Nobs = ex3scadNobs
          ClassInfo = ex3scadClassInfo
          Dimensions = ex3scadDimensions
          SelectionInfo = ex3scadSelectionInfo
          Summary.SelectionSummary = ex3scadSummary
          Summary.SelectionReason = ex3scadSelectionReason
          Summary.SelectedEffects = ex3scadSelectedEffects
          SelectedModel.FitStatistics = ex3scadFitStatistics
          SelectedModel.ParameterEstimates = ex3scadParameterEstimates;
   run;

    %startprint(ex3scadInfoPrint);
    title "Basic Information about SCAD Selection";
    data _null_;
	    set work.ex3scadNobs;
	    file print ods = (template = 'ACAS.REGSELECT.Nobs');
         put _ods_;
    run;
    title;
    data _null_;
	    set work.ex3scadClassInfo;
	    file print ods = (template = 'ACAS.REGSELECT.ClassLevels');
         put _ods_;
    run;
    title;
    data _null_;
	    set work.ex3scadDimensions;
	    file print ods = (template = 'ACAS.REGSELECT.Dimensions');
         put _ods_;
    run;
    title;
    data _null_;
	    set work.ex3scadSelectionInfo;
	    file print ods = (template = 'ACAS.REGSELECT.SelectionInfo');
         put _ods_;
    run;
    %endprint;

    %startprint(ex3scadSummaryPrint);
    data _null_;
       set work.ex3scadSummary;
       if _n_ le 13  or  _n_ ge 31;
       if 11 le _n_ le 13 then do;
       Step = .;  Alpha= .; Lambda= .; nEffectsIn = .;
       ValidationASE= .; ObjectValue= .; ConvergenceStatus= .; end;
       file print ods = (template = 'ACAS.REGSELECT.FCPSelectionSummary');
       put _ods_;
    run;
    title;
    data _null_;
	    set work.ex3scadSelectionReason;
	    file print ods = (template = 'ACAS.REGSELECT.SelectionReason');
         put _ods_;
    run;
    title;
    data _null_;
	    set work.ex3scadSelectedEffects;
	    file print ods = (template = 'ACAS.REGSELECT.SelectedEffects');
         put _ods_;
    run;
    %endprint;

    %startprint(ex3scadFitStatisticsPrint);
    title "Details of the Model Selected by SCAD Method";
    data _null_;
	    set work.ex3scadFitStatistics;
	    file print ods = (template = 'ACAS.REGSELECT.FitStatistics');
         put _ods_;
    run;
    title;
    data _null_;
	    set work.ex3scadParameterEstimates;
	    file print ods = (template = 'ACAS.REGSELECT.ParameterEstimates');
         put _ods_;
    run;
    %endprint;
    ods graphics off;

   proc regselect data=mycas.baseball;
       partition roleVar = league(train='National' validate='American');
       class division;
       model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                         yrMajor crAtBat crHits crHome crRuns crRbi
                         crBB nOuts nAssts nError;
       selection  method = scad(alpha=2.7 solver=NLP
                  choose=validate) details=all;
   run;

   proc regselect data=mycas.baseball;
       partition roleVar = league(train='National' validate='American');
       class division;
       model logSalary = division nAtBat nHits nHome nRuns nRBI nBB
                         yrMajor crAtBat crHits crHome crRuns crRbi
                         crBB nOuts nAssts nError;
       selection  method = mcp(alpha=1.7 choose=validate) details=all;
   run;

