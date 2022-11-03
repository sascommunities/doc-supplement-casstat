/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NLMODEX1                                            */
/*   TITLE: Documentation Example 1 for PROC NLMOD              */
/* PRODUCT: VIYA Statistics                                     */
/*    KEYS: Program logic flow, Continuity condition            */
/*   PROCS: NLMOD                                               */
/*    MISC: Logic Flow Example for PROC NLMOD Segmented Model   */
/*                                                              */
/****************************************************************/

data mycas.A;
   input y x @@;
   datalines;
.46 1  .47  2 .57  3 .61  4 .62  5 .68  6 .69  7
.78 8  .70  9 .74 10 .77 11 .78 12 .74 13 .80 13
.80 15 .78 16
 ;

proc nlmod data=mycas.A out=mycas.B;
   parms alpha=.45 beta=.05 gamma=-.0025;

   x0 = -.5*beta / gamma;

   if (x < x0) then
        yp = alpha + beta*x  + gamma*x*x;
   else
        yp = alpha + beta*x0 + gamma*x0*x0;

   model y ~ residual(yp);

   estimate 'join point' -beta/2/gamma;
   estimate 'plateau value c' alpha - beta**2/(4*gamma);
   predict 'predicted' yp pred=yp;
   predict 'response' y pred=y;
   predict 'x' x pred=x;
run;

data B;
   set mycas.B;
run;

proc sort data = B;
   by x;
run;

proc sgplot data=B noautolegend;
   yaxis label='Observed or Predicted';
   refline 0.7775  / axis=y label="Plateau"    labelpos=min;
   refline 12.7477 / axis=x label="Join point" labelpos=min;
   scatter y=y  x=x;
   series  y=yp x=x;
run;

