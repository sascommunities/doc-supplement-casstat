/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamselex2                                           */
/*   TITLE: Example 2 for PROC GAMSELECT                        */
/*    DESC:                                                     */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: cross validation, early stopping,                   */
/*          boosting                                            */
/*   PROCS: GAMSELECT                                           */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

proc cas;
   dataStep.runCode result=r/
      single='yes' code=
      'data one;
          call streaminit(1);
          array v{200} v1-v200;
          do i=1 to 10000;
             do j=1 to 200;
                v{j}=rand("normal");
             end;
             f1=-2*sin(2*v1);
             f2=v2*v2-1./3;
             f3=v3-0.5;
             f4=exp(-v4)+exp(-1)-1;
             linp=f1+f2+f3+f4;
             y=rand("normal",linp);
             output;
          end;
       run;'
   ;
   run;
quit;

proc sql noprint;
   select cat("spline(",strip(name),")") into :splineTerms separated by ' '
   from dictionary.columns
   where libname = "MYCAS" and memname = "ONE" and
   upcase(name) like 'V%';
quit;

proc gamselect data=mycas.one plots=all;
   model y = &splineTerms;
   selection method=boosting;
run;

data mycas.one / single=yes;
  set mycas.one;
  call streaminit(1848);
  cvFold = rand("table",0.2,0.2,0.2,0.2,0.2);
run;

proc gamselect data=mycas.one plots=all;
   model y = &splineTerms;
   selection method=boosting(choose=CV index=cvFold
             stopHorizon=10 stopTol = 0.0005);
run;

proc gamselect data=mycas.one plots=all;
   model y = spline(v1 / df = 10) spline(v2) spline(v3) spline(v4);
   selection method=boosting(choose=CV index=cvFold
             stopHorizon=10 stopTol = 0.0005);
run;

