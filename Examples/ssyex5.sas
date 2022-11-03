/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SSYEX5                                              */
/*   TITLE: Example 5 for PROC SIMSYSTEM                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation                                          */
/*   PROCS: SIMSYSTEM SURVEYSELECT SUMMARY                      */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMSYSTEM, EXAMPLE 5.                          */
/*    MISC:                                                     */
/****************************************************************/

/*
/  Run SIMSYSTEM with moment combinations specially chosen to span
/  all families of Pearson distributions, plus the normal.
/---------------------------------------------------------------------*/

%let Mean   = -4.5 -3.5 -2.5 -1.5 -0.5  0.5        1.5  2.5        3.5  4.5;
%let Stddev =  1    2    3    4    5    6          7    8          9   10;
%let Skew   =  0   -1.5  1.8 -1.3  0   -2.00831604 0.1 -1.04235831 1.7  0;
%let Kurt   =  3    5.7  7.4  3    2.1  9.05       6    5.15       8.6  3.2;
proc simsystem system=pearson;
   moments mean=&Mean StdDev=&Stddev skew=&Skew kurt=&Kurt;
   ods output Parameters=Parm;
run;

proc print data=Parm noobs;
   var Family Notes Shap: Shift Scale;
run;

/*
/  Now, check the formulae for using the family and the computed
/  parameters to draw random samples.
/---------------------------------------------------------------------*/

%let N = 1000000;
data mycas.Parm; set Parm; run;
proc ds2 sessref=mysess;
data Sim / overwrite=yes;
   dcl int i;
   dcl double y;
   method run();
      set Parm;
      streaminit(15531);
      do i=1 to &N;
         select (trim(left(Family)));
            when ('Type I'   )
            when ('Type I(J)')
            when ('Type I(U)') y =   rand('beta'  ,Shap1Val,Shap2Val);
            when ('Type II'  ) y =   rand('beta'  ,Shap1Val,Shap1Val);
            when ('Type III' ) y =   rand('gamma' ,Shap1Val);
            when ('Type IV'  ) y = .;
            when ('Type V'   ) y = 1/rand('gamma' ,Shap1Val);
            when ('Type VI'  ) y =   rand('f'     ,Shap1Val,Shap2Val);
            when ('Type VII' ) y =   rand('t'     ,Shap1Val);
            when ('Normal'   ) y =   rand('normal');
         end;
         y = Scale*y + Shift;
         output;
      end;
   end;
enddata;
run;
quit;

proc mdsummary data=mycas.Sim;
   var y;
   groupby Family Notes Mean StdDev Skewness Kurtosis;
   output out=mycas.Sim_summary;
run;

proc cas;
   session mysess;
   table.alterTable /
      name="Sim_summary"
      columns={
         {name="_Mean_"       rename="sMean"},
         {name="_Std_"        rename="sStdDev"},
         {name="_Skewness_"   rename="sSkewness"},
         {name="_Kurtosis_"   rename="sKurtosis"}
      };
   table.update /
      table="Sim_summary"
      set={{var="sKurtosis" value="sKurtosis + 3"}};
quit;

proc sort data=mycas.Sim_summary out=Sim_summary; by Family; run;
proc print data=Sim_summary noobs;
   var Family Mean sMean StdDev sStdDev Skewness sSkewness Kurtosis sKurtosis;
   format _NUMERIC_ 6.3;
run;

/*
/  It's exactly the same rigmarole for Johnson distributions, except
/  that the formulae for using the family and the computed
/  parameters to draw random samples are different.
/---------------------------------------------------------------------*/

%let Mean   =  -2   -1    0            1  2  ;
%let Stddev =   1    2    3            4  5  ;
%let Skew   =  -1.6  2.5 -1.2922847983 0 -0.7;
%let Kurt   =   7.5  8.4  6.1093660061 3  7  ;
proc simsystem system=johnson;
   moments mean=&Mean StdDev=&Stddev skew=&Skew kurt=&Kurt;
   ods output Parameters=Parm;
run;

%let N = 1000000;
data mycas.Parm; set Parm; run;
proc ds2 sessref=mysess;
data Sim / overwrite=yes;
   dcl int i;
   dcl double y z;
   method run();
      set Parm;
      streaminit(15531);
      do i = 1 to &N;
         z = rand('normal');
         select (trim(left(Family)));
            when ('SB(1)')
            when ('SB(2)') y = 1/(1 + exp(-(z - Gamma)/Delta));
            when ('SL'   ) y =        exp(  z         /Delta) ;
            when ('SU'   ) y =       sinh( (z - Gamma)/Delta) ;
            when ('SN'   ) y =              z                 ;
         end;
         y = Scale*y + Shift;
         output;
      end;
   end;
enddata;
run;
quit;

proc mdsummary data=mycas.Sim;
   var y;
   groupby Family Mean StdDev Skewness Kurtosis;
   output out=mycas.Sim_summary;
run;

proc cas;
   session mysess;
   table.alterTable /
      name="Sim_summary"
      columns={
         {name="_Mean_"       rename="sMean"},
         {name="_Std_"        rename="sStdDev"},
         {name="_Skewness_"   rename="sSkewness"},
         {name="_Kurtosis_"   rename="sKurtosis"}
      };
   table.update /
      table="Sim_summary"
      set={{var="sKurtosis" value="sKurtosis + 3"}};
quit;

proc sort data=mycas.Sim_summary out=Sim_summary; by Family; run;
proc print data=Sim_summary noobs;
   var Family Mean sMean StdDev sStdDev Skewness sSkewness Kurtosis sKurtosis;
   format _NUMERIC_ 6.3;
run;

