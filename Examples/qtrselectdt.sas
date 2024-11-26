/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qtrselectdt                                         */
/*   TITLE: Details Section Examples for PROC QTRSELECT         */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection                                     */
/*   PROCS: QTRSELECT                                           */
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

proc qtrselect data=mylib.splitExample;
   class c1(split) c2(order=freq);
   model y = c1 c2 x1 x2;
   selection method=forward;
run;



/****************************************************************/
/*  Details Section:  Validation and Test Data Example              */
/****************************************************************/

%let seed=321;
%let n=600;
%let p=10;

data mylib.roleExample;
   array x{&p} x1-x&p;
   length r $8;
   drop i j k;

   do i=1 to &n;
      do j=1 to &p;
         x{j} = ranuni(&seed);
      end;

      y  = x1 + x2 + x3 + ranuni(&seed);

      k = mod(i,3);
      if      k=0 then r = 'train';
      else if k=1 then r = 'validate';
      else if k=2 then r = 'test';
      output;
   end;
run;


proc qtrselect data=mylib.roleExample;
   model y = x1-x&p;
   selection method=forward(select=validate stop=sbc);
   partition rolevar=r(train='train' validate='validate' test='test');
run;


