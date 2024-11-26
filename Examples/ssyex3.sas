/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SSYEX3                                              */
/*   TITLE: Example 3 for PROC SIMSYSTEM                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation                                          */
/*   PROCS: SIMSYSTEM SUMMARY RSREG                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMSYSTEM, EXAMPLE 3.                          */
/*    MISC:                                                     */
/****************************************************************/

/*
/ Generate representative Johnson distributions for S & P 500 returns.
/---------------------------------------------------------------------*/

proc simsystem system=johnson;
   momentgrid Skewness = -1.0 -0.5 0.0
              Kurtosis =  2.3  3.1 3.9;
run;

/*
/ Simulate from representative Johnson distributions for S & P 500
/ returns.
/---------------------------------------------------------------------*/

proc simsystem n=30 system=johnson seed=12345 noprint nrep=1000;
   momentgrid
      Mean     =   7.5 12.0 16.5
      StdDev   =  17.0 20.0 23.0
      Skewness =  -1.0 -0.5  0.0
      Kurtosis =   2.3  3.1  3.9;
   output out=mylib.Sim_raw Mean=Mean Std=StdDev;
run;

proc ds2 sessref=mysess;
   data Sim / overwrite=yes;
      rename Variate=AnnualReturn;
      method run();
         set Sim_raw;
         if ^((Skewness = -1) & (Kurtosis = 2.3)) then output;
      end;
   enddata;
run;
quit;

/*
/ Evaluate the success of each simulated sequence of 30 returns.
/---------------------------------------------------------------------*/

%let Start    = 1000000;
%let Withdraw =   40000;
proc ds2 sessref=mysess;
   thread Success_thd / overwrite=yes;
      dcl double Value minVal;
      dcl int Success;
      retain Value minVal;
      keep SimIndex Mean StdDev Skewness Kurtosis Rep Success;
      method run();
         set Sim;  /*being parallelized*/
         by SimIndex Rep;
         /*BY statement takes the BY-groups as batches in threads*/
         if FIRST.Rep then do;        /* First year in a sequence: */
            Value  = 1000000;         /* Initialize the portfolio  */
            minVal = Value;           /* value.                    */
         end;
         /*
         /  The value at the end of the year is the sum of the
         /  original value and the annual return, minus the amount
         /  withdrawn.
         /---------------------------------------------------------*/
         if Value then do;
            Value  = Value + (AnnualReturn/100)*Value - 40000;
            minVal = min(minVal, Value);
         end;
         if LAST.Rep then do;         /* Last year in a sequence:  */
            Success = (minVal > 0);   /* Evaluate success and      */
            output;                   /* output.                   */
         end;
      end;
   endthread;
   data Success / overwrite=yes;
      dcl thread Success_thd Success_thd_instance;
      method run();
         set from Success_thd_instance threads=1;
      end;
   enddata;
run;
quit;

proc mdsummary data=mylib.Success;
   groupby Mean StdDev Skewness Kurtosis SimIndex;
   var Success;
   output out=mylib.ProbSuccess;
run;

proc cas;
   session mysess;
   table.alterTable /
      name="ProbSuccess"
      columns={{name="_Mean_" rename="ProbSuccess" label=""}};
quit;

/*
/ Use response surface methods to analyze simulated success rates.
/---------------------------------------------------------------------*/

proc rsreg data=mylib.ProbSuccess plots=contour(nodesign);
   model ProbSuccess = Mean StdDev Skewness Kurtosis;
   ods select FactorANOVA Contour;
run;

