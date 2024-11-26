/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICAEX1                                              */
/*   TITLE: Documentation Example 1 for PROC ICA                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multivariate Analysis                               */
/*   PROCS: ICA                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ICA, Example 1                                 */
/*    MISC:                                                     */
/****************************************************************/

data mylib.ex1data;
   keep t x:;
   array S[200,3];     /* S: source signals */
   array A[3,3];       /* A: mixing matrix */
   array x[4] x1-x4;   /* X: observed signals */

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
      x[4] = 0.1*uniform(67890);
      output;
   end;
run;

/* Extract independent components with dimension reduction */

proc ica data=mylib.ex1data eigthresh=0.004 noscale seed=345;
   var x1-x4;
   output out=mylib.scores1 component=c copyvar=t;
run;

proc template;
   define statgraph ScoresPanel;
      beginGraph;
         layout lattice / rows=3
                          columns=1
                          rowgutter=10
                          columndatarange=unionall
                          order=packed;

         columnaxes;
            columnaxis / label="t";
         endcolumnaxes;

         layout overlay / yaxisopts=
            (linearopts=(viewmin=-3 viewmax=3 tickvaluelist=(-3 0 3)));
            seriesplot x=t y=c1;
         endlayout;

         layout overlay / yaxisopts=
            (linearopts=(viewmin=-2 viewmax=2 tickvaluelist=(-2 0 2)));
            seriesplot x=t y=c2;
         endlayout;

         layout overlay / yaxisopts=
            (linearopts=(viewmin=-2 viewmax=2 tickvaluelist=(-2 0 2)));
            seriesplot x=t y=c3;
         endlayout;

         endlayout;
      endGraph;
   end;
run;

proc sgrender data=mylib.scores1 template=ScoresPanel;
run;

/* Extract independent components with full dimensions */

proc ica data=mylib.ex1data noscale seed=345;
   var x1-x4;
   output out=mylib.scores2 component=c copyvar=t;
run;

