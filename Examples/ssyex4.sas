/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SSYEX4                                              */
/*   TITLE: Example 4 for PROC SIMSYSTEM                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation                                          */
/*   PROCS: SIMSYSTEM SUMMARY AUTOREG                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMSYSTEM, EXAMPLE 4.                          */
/*    MISC:                                                     */
/****************************************************************/

/*
/  Simulate and fit a GARCH process.  Modelled on the code given in
/  the SAS/ETS example "Estimating GARCH Models", available on the
/  SAS support site.
/---------------------------------------------------------------------*/

data Index;
   call streaminit(12345);
   do t = 1 to 10000;
      e = normal(2);
      output;
      end;
run;

data Index; set Index;
   retain ReturnRate Var eLag varLag;
   if (_N_ = 1) then do;
      eLag   = 1;
      VarLag = 1;
      end;
   Var = 0.4 + 0.8 * eLag**2  + 0.1 * VarLag;
   ReturnRate = sqrt(Var) * e;
   output;
   eLag   = ReturnRate;
   varLag = Var;
run;

proc autoreg data=Index;
   model ReturnRate = / noint garch=(p=1, q=1) dist=t;
   output out=o1 alphacli=%sysevalf(2*0.05) lcl=lcl;
run;

/*
/ Count up the proportion of returns that are less than -VaR.
/---------------------------------------------------------------------*/

data o1; set o1;
   AtRisk = (ReturnRate < lcl);
proc means data=o1 mean;
   var AtRisk;
run;

/*
/  Simulate conditional returns from each of a systematic grid of
/  mostly nonnormal distributions.
/---------------------------------------------------------------------*/

proc simsystem n=10000 system=pearson seed=1 plot(only)=mrmap(skewscale=skewness);
   momentgrid skew=-1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1
              kurt=1.25  1.5
                   1.75  1.8
                   1.85  2.0
                   2.1   2.5
                   3     3.5
                   6    10;
   output out=mylib.GARCHSim_error;
run;

proc cas;
   session mysess;
   table.alterTable /
      name="GARCHSim_error"
      columns={
         {name="iObs"    rename="t" label=""},
         {name="Variate" rename="e" label=""}
      };
quit;

/*
/  Perform GARCH analysis of returns over the grid of distributions.
/---------------------------------------------------------------------*/

/*using THREAD to parallelize the set statement*/
proc ds2 sessref=mysess;
thread GARCHSim_thd / overwrite=yes;
   dcl double ReturnRate Var eLag VarLag;
   retain ReturnRate Var eLag VarLag;
   method run();
      set GARCHSim_error;
      by SimIndex;
      if FIRST.SimIndex then do;
         eLag   = 1;
         VarLag = 1;
      end;
      Var = 0.4 + 0.8 * eLag**2 + 0.1 * VarLag;
      ReturnRate = sqrt(Var) * e;
      output;
      eLag   = ReturnRate;
      VarLag = Var;
   end;
endthread;
data GARCHSim / overwrite=yes;
   dcl thread GARCHSim_thd GARCHSim_thd_instance;
   method run();
      set from GARCHSim_thd_instance;
   end;
enddata;
run;
quit;

proc autoreg data=mylib.GARCHSim noprint;
   by notsorted Skewness Kurtosis;
   model ReturnRate = / noint garch=(p=1, q=1);
   output out=mylib.g11 alphacli=%sysevalf(2*0.05) lcl=lcl;
run;

data g11; set mylib.g11;
   AtRisk = (ReturnRate < lcl);
proc summary data=g11 mean;
   class Kurtosis Skewness;
   ways 2;
   var AtRisk;
   output out=AtRisk mean=pAtRisk;
run;

/*
/  Pretty-print the results.
/---------------------------------------------------------------------*/

proc sort data=AtRisk;
   by Kurtosis Skewness;
proc transpose data=AtRisk(rename=(Skewness=_NAME_)) out=AtRisk;
   by Kurtosis;
   var pAtRisk;
proc print data=AtRisk(drop=_NAME_) noobs label;
   var N1 N0D75 N0D5 N0D25 _0 _0D25 _0D5 _0D75 _1;
   id Kurtosis;
   format _: N: 6.3;
   label
      N1    = "-1"
      N0D75 = "-0.75"
      N0D5  = "-0.5"
      N0D25 = "-0.25"
      _0    =  "0"
      _0D25 =  "0.25"
      _0D5  =  "0.5"
      _0D75 =  "0.75"
      _1    =  "1";
run;

