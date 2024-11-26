/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamselectgs1                                        */
/*   TITLE: Getting Started Example 1 for PROC GAMSELECT        */
/*    DESC: Generalized additive model selection by boosting    */
/* PRODUCT: SAS Visual Statistics                              */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Boosting, generalized additive models                */
/*   PROCS: GAMSELECT                                           */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/****************************************************************/

data mylib.getStarted;
  drop i j w;

  array x{90};
  call streaminit(4321);
  pi=constant("pi");

  do i=1 to 20000;
      u = ranuni(12345);
      do j=1 to dim(x);
         w    = ranuni(12345);
         x{j} = (w + u)/2;
      end;
      f1 = x1;
      f2 = (2*x2-1)**2;
      f3 = sin(2 * pi * x3)/(2-sin(2*pi*x3));
      f4 = 0.1*sin(2*pi*x4) + 0.2*cos(2*pi*x4)+0.3*sin(2*pi*x4)**2
         + 0.4*cos(2*pi*x4)**3+0.5*sin(2*pi*x4)**3;
      linp = 5*f1+3*f2+4*f3+6*f4;
      y =  linp + 1.32 * rand("Normal");
      output;
   end;
run;

ods graphics on;
proc gamselect data= mylib.getStarted plots=all;
   model y = spline(x1 ) spline(x2 ) spline(x3 ) spline(x4 ) spline(x5 )
             spline(x6 ) spline(x7 ) spline(x8 ) spline(x9 ) spline(x10)
             ;
   selection method=boosting;
run;

%macro SplinePrefixList(prefix,n);
   %do i = 1 %to &n;
      spline(&prefix.&i)
      %end;
%mend;


ods graphics on;
proc gamselect data= mylib.getStarted plots=all;
   model y = %SplinePrefixList(x,90);
   selection method=boosting;
run;

