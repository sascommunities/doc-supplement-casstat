/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regselectdt                                         */
/*   TITLE: Details Section Examples for PROC REGSELECT         */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection                                     */
/*   PROCS: REGSELECT                                           */
/*                                                              */
/****************************************************************/

/****************************************************************/
/*  Details Section: Class Variable Split Example              */
/****************************************************************/

data mylib.splitExample;
   length c2 $6;
   drop i;
   do i=1 to 1000;
     c1 = 1 + mod(i,6);
     if      i < 200 then c2 = 'low';
     else if i < 500 then c2 = 'medium';
     else                 c2 = 'high';
     x1 = ranuni(1);
     x2 = ranuni(1);
     y = x1+3*(c2 ='low')  + 10*(c1=3) +5*(c1=5) + rannor(1);
     output;
   end;
run;

proc regselect data=mylib.splitExample;
   class c1(split) c2(order=freq);
   model y = c1 c2 x1 x2;
   selection method=forward;
run;

