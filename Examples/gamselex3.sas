/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamselex3                                           */
/*   TITLE: Example 3 for PROC GAMSELECT                        */
/*    DESC:                                                     */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: shrinkage, adaptive                                 */
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

proc gamselect data=mycas.one seed=123 plots=all;
   model y = &splineTerms;
   selection method=shrinkage(distributedSearch=yes);
run;

proc gamselect data=mycas.one seed=123 plots=all;
   model y=spline(v1 / weight1=0.716  weight2=0.075)
           spline(v2 / weight1=0.693  weight2=0.206)
           spline(v3 / weight1=1.046  weight2=17.62)
           spline(v4 / weight1=0.488  weight2=0.090)
           spline(v15/ weight1=343.5  weight2=34.68);
   selection method=shrinkage(distributedSearch=yes);
run;

