/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: modelmatrixex1                                      */
/*   TITLE: Example 1 for PROC MODELMATRIX                      */
/*    DESC: Simulated Data                                      */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, Validation                         */
/*   PROCS: MODELMATRIX                                         */
/*                                                              */
/****************************************************************/


 data mycas.sample;
 call streaminit(1);
     do byVar=1 to 2;
       do i=1 to 10;
                if byVar=1 then c=rand("Integer",0,3);
          else  if byVar=2 then c=rand("Integer",0,1);
          x=rand("Normal");
          y=1;
          wgt = 1;
          if i=5 and byVar=2 then frq  = -1; else frq=1;
          index + 1;
          output;
       end;
     end;
 run;


 data sample;
   set mycas.sample;
 run;

 proc print data=sample;
 run;

 proc modelmatrix data=mycas.sample nthreads=1;
   by byVar;
   class c;
   freq frq;
   weight wgt;
   effect spl= spline(x);
   model y = x c spl x*c;
   output out=mycas.designMat prefix=param copyVars=(c frq index);
 run;

 data work.designMat;
   set mycas.designMat;
 run;

 proc print data=designMat;
   format BEST 5. param1-param17;
   var index c frq param1-param7 param17;
   where
     (index < 11) or
     (index = 15);
 run;

