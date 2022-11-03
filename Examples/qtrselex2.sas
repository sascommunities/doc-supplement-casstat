/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qtrselex2                                           */
/*   TITLE: Example 2 for PROC QTRSELECT                        */
/*    DESC: Body Mass Index Data                                */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Body Mass Index                                     */
/*   PROCS: QTRSELECT                                           */
/*                                                              */
/****************************************************************/

proc contents varnum data=sashelp.BMIMen;
   ods select position;
run;

   data mycas.BMIMen;
      set sashelp.BMIMen;
      SqrtAge = sqrt(Age);
      InveAge = 1/Age;
      LogBMI  = log(BMI);
   run;

%let quantile=0.03 0.05 0.1 0.25 0.5 0.75 0.85 0.90 0.95 0.97;
%let nq=10;

proc qtrselect data=mycas.BMIMen;
   model logBMI = InveAge SqrtAge Age SqrtAge*Age Age*Age Age*Age*Age
         / quantile=&quantile;
   output out=mycas.BMIOut copyvars=(BMI Age) pred=P_LogBMI;
run;

/****************************************************************/
/*  SAS Macro for Plotting Multiple Quantile Curves.            */
/****************************************************************/

%let BMIcolor=red olive orange blue brown gray violet black gold green;

%macro plotBMI;
   data BMIPred;
      set mycas.BMIOut;
      %do j=1 %to &nq;
         predBMI&j = exp(P_LogBMI&j);
      %end;
      label %do j=1 %to &nq;
               predBMI&j=%qscan(&quantile,&j,%str( ))
            %end;;
   run;

   proc sort data=BMIPred;
      by Age;
   run;

   proc sgplot data=BMIPred;
      %do j=1 %to &nq;
         series y=predBMI&j x=Age/lineattrs=(thickness=2
         color=%qscan(&BMIcolor,&j,%str( )));
      %end;
      scatter y=BMI x=Age/markerattrs=(size=5);
   run;
%mend;

%plotBMI;

