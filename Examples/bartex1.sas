/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bartex1                                             */
/*   TITLE: Example 1 for PROC BART                             */
/*    DESC: Storing model fit and scoring new data              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: BART, store, score, score margin                    */
/*   PROCS: BART                                                */
/*    DATA: simulated                                           */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/


data mycas.inputData / single =yes;
   drop  j w1-w40;

  array x{40};
  array w{40};
  call streaminit(6524);
  pi=constant("pi");

   do i=1 to 10000;
      u = rand("Uniform");
      do j=1 to dim(x);
         w{j} = rand("Uniform");
         x{j} = (w{j} + u)/2;
      end;

      f1 = sin(pi * x1 * x2 );
      f2 = (x3-0.5)**2;
      f3 = x4;
      f4 = x5;
      fb = 10*f1 +20*f2+10*f3+5*f4;

      y = fb +  rand("Normal");
      output;
   end;

run;

proc bart data=mycas.inputData seed=9181 trainInMem mapInMem;
   model y = x1-x40;
   store mycas.modelFit;
run;


data mycas.toScoreData / single =yes;
   drop  j w1-w40;

  array x{40};
  array w{40};
  call streaminit(1972);
  pi=constant("pi");

   do i=1 to 1000;
      u = rand("Uniform");
      do j=1 to dim(x);
         w{j} = rand("Uniform");
         x{j} = (w{j} + u)/2;
      end;

      f1 = sin(pi * x1 * x2 );
      f2 = (x3-0.5)**2;
      f3 = x4;
      f4 = x5;
      fb = 10*f1 +20*f2+10*f3+5*f4;

      y = fb +  rand("Normal");
      output;
   end;

run;

proc cas;
   action bart.bartScore /
      table   = {name="toScoreData"}
      restore = {name="modelFit"}
      casOut  = {name="scoredData", replace=TRUE}
      pred    = "predResp"
      resid   = "residual";
   run;
quit;

data fitCheck;
   set mycas.scoredData;
   SquareError = residual * residual;
run;

proc means data=fitCheck mean;
   var SquareError;
run;

proc cas;
   action bart.bartScoreMargin /
      table   = {name="inputData"}
      restore = {name="modelFit"}
      marginInfo = TRUE
      margins= {
        { name="Scenario1", at={{var="x2" value=0.25}}}
        { name="Scenario2", at={{var="x2" value=0.25} {var="x3" value=0.5} }}
        { name="x1Ref",     at={{var="x1" value=0.25}} }
        { name="x1Evt1",    at={{var="x1" value=0.5}} }
        { name="x1Evt2",    at={{var="x1" value=0.75}} }
      }
      differences = {
        { label="x1:0.5 - 0.25" refMargin="x1Ref" evtMargin="x1Evt1"}
        { label="x1:0.75 - 0.25" refMargin="x1Ref" evtMargin="x1Evt2"}
      };
   run;
quit;

