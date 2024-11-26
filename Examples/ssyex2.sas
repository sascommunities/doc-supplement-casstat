/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SSYEX2                                              */
/*   TITLE: Example 2 for PROC SIMSYSTEM                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: simulation                                          */
/*   PROCS: SIMSYSTEM UNIVARIATE                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SIMSYSTEM, EXAMPLE 2.                          */
/*    MISC:                                                     */
/****************************************************************/

/*
/ Generate Johnson distributions over a grid of skewness and kurtosis
/ values that is evenly spaced on the squared-skewness scale, and
/ compute the expected coverage of three-sigma limits.
/---------------------------------------------------------------------*/

data mylib.Grid;
   do s2 = 0 to 10 by 0.05;
      do Kurtosis = 1 to 11 by 0.05;
         Skewness = sqrt(s2);
         output;
         end;
      end;
run;

ods select none;
proc simsystem data=mylib.Grid system=johnson cumprob=-3 3 plot=none;
   ods output Parameters=SKProbJ;
run;
ods select all;

data SKProbJ; set SKProbJ;
   Coverage = P2 - P1;
   s2 = Skewness*Skewness;
   format Coverage percent6.;
run;

/*
/ Plot the coverage over the skewness/kurtosis grid.
/---------------------------------------------------------------------*/

proc sgrender data=SKProbJ template=acas.simsystem.Graphics.S2KContourMap;
   dynamic _Title = "Three-Sigma Coverage for Johnson Distributions"
           _XVar  = "s2"
           _YVar  = "Kurtosis"
           _ZVar  = "Coverage";
run;

/*
/ Generate densities for distributions with low coverage.
/---------------------------------------------------------------------*/

data mylib.LowCoverage;
   do s2 = 7 to 10 by 0.5;
      do Kurtosis = 8 to 11 by 0.5;
         Skewness = sqrt(s2);
         if (1 + s2 < Kurtosis <= 1 + s2 + 0.5) then
            output;
         end;
      end;
run;

proc simsystem data=mylib.LowCoverage system=johnson
               plots=mrmap(skewscale=square);
run;

