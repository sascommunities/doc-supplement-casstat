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


data mylib.inputData / single =yes;
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

proc bart data=mylib.inputData seed=9181 trainInMem mapInMem;
   model y = x1-x40;
   store mylib.modelFit;
run;


data mylib.toScoreData / single =yes;
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

proc bart data=mylib.toScoreData restore=mylib.modelFit;
   output out = mylib.scoredData pred = predResp resid = residual;
run;

data fitCheck;
   set mylib.scoredData;
   SquareError = residual * residual;
run;

proc means data=fitCheck mean;
   var SquareError;
run;

proc bart restore = mylib.modelFit data=mylib.inputData;
   margin "Scenario1" x2 = 0.25;
   margin "Scenario2" x2 = 0.25 x3 = 0.5;
   margin "x1Ref"     x1 = 0.25;
   margin "x1Evt1"    x1 = 0.5;
   margin "x1Evt2"    x1 = 0.75;
   margindiff event = "x1Evt1" ref = "x1Ref" / label= "x1:0.5 - 0.25";
   margindiff event = "x1Evt2" ref = "x1Ref" / label= "x1:0.75 - 0.25";
run;

