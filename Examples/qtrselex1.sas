/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qtrselex1                                           */
/*   TITLE: Example 1 for PROC QTRSELECT                        */
/*    DESC: Simulated Data                                      */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, Validation                         */
/*   PROCS: QTRSELECT                                           */
/*                                                              */
/****************************************************************/

%let seed=321;
%let p=20;
%let n=3000;

data analysisData;
   array x{&p} x1-x&p;
   do i=1 to &n;
      U  = ranuni(&seed);
      x1 = ranuni(&seed);
      x2 = ranexp(&seed);
      x3 = abs(rannor(&seed));
      y  = x1*(U-0.1) + x2*(U*U-0.25) + x3*(exp(U)-exp(0.9));
      do j=4 to &p;
         x{j} = ranuni(&seed);
      end;
      output;
   end;
run;

data mycas.analysisData;
   set analysisData;
run;

proc qtrselect data=mycas.analysisData;
   model y= x1-x&p / quantile=0.1 0.5 0.9 clb;
   selection method=forward;
   output out=mycas.out p=pred;
run;


