/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICAGS                                               */
/*   TITLE: Getting Started Example for PROC ICA                */
/* PRODUCT: AASTATISTICS                                        */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multivariate Analysis                               */
/*   PROCS: ICA                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ICA, Getting Started Example                   */
/*    MISC:                                                     */
/****************************************************************/

title 'Getting Started: Independent Component Analysis';

data mycas.sample;
   keep t x:;
   array S[200,3];     /* S: source signals */
   array A[3,3];       /* A: mixing matrix */
   array x[3] x1-x3;   /* X: mixed signals */

   N = 200;

   do i = 1 to 3;
      do j = 1 to 3;
         A[i,j] = 0.7*uniform(12345);
      end;
   end;

   do i = 1 to N;
      S[i,1] = cos(i/3);
      S[i,2] = 0.4*((mod(i,23)-11)/7)**5;
      S[i,3] = ((mod(i,29)-7)/11)-0.7;
   end;

   do i = 1 to N;
      t = i;
      do j = 1 to 3;
         x[j] = 0;
         do k = 1 to 3;
            x[j] = x[j] + S[i,k]*A[k,j];
         end;
      end;
      output;
   end;
run;

proc ica data=mycas.sample seed=345;
   var x1-x3;
   output out=mycas.scores component=c copyvar=t;
run;

