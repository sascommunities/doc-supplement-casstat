/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PCAEX3                                              */
/*   TITLE: Documentation Example 3 for PROC PCA                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multivariate Analysis                               */
/*   PROCS: PCA                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PCA, Example 3                                 */
/*    MISC:                                                     */
/****************************************************************/

data mylib.testdata;
   title;
   keep x:;
   drop rank number_of_obs number_of_var sigma ii idum;
   drop rv1 rv2 rsq fac row col;
   drop nobs_per_thread nextras start_obs obs j k;
   array B[50,2000];          /* dimensions: rank, number_of_var */
   array A[50];               /* dimension: rank */
   array x[2000] x1-x2000;    /* dimension: number_of_var */

   target_nthreads = min(_nthreads_,96);
   if (_threadid_ = 1) then
      put "Number of threads = " target_nthreads;
   rank=50;
   number_of_obs=10000;
   number_of_var=2000;
   sigma=0.1;

   call streaminit(1);

   if (_threadid_ <= target_nthreads) then do;
      ii = 0;
      idum = 0;
      do while (ii < rank * number_of_var);
         idum = mod(mod(1664525*idum,4294967296)+1013904223,4294967296);
         rv1 = 2.0*(idum/4294967296)-1.0;
         idum = mod(mod(1664525*idum,4294967296)+1013904223,4294967296);
         rv2 = 2.0*(idum/4294967296)-1.0;
         rsq = rv1*rv1+rv2*rv2;
         if ((rsq < 1.0) and (rsq ^= 0.0)) then do;
            fac = sqrt(-2.0*log(rsq)/rsq);
            row = int(ii/number_of_var)+1;
            col = mod(ii,number_of_var)+1;
            B[row,col] = rv1*fac;
            ii = ii + 1;
            if (ii < rank * number_of_var) then do;
               row = int(ii/number_of_var)+1;
               col = mod(ii,number_of_var)+1;
               B[row,col] = rv2*fac;
               ii = ii + 1;
            end;
         end;
      end;

      nobs_per_thread = int(number_of_obs /target_nthreads);
      nextras = number_of_obs - nobs_per_thread*target_nthreads;
      if (_threadid_ <= nextras) then do;
         nobs_per_thread = nobs_per_thread+1;
         start_obs = (_threadid_-1)*nobs_per_thread+1;
      end;
      else
         start_obs = nextras+(_threadid_-1)*nobs_per_thread+1;

      do obs = start_obs to (start_obs+nobs_per_thread-1);
         do j = 1 to rank;
            A[j] = rand('Normal');
         end;
         do k = 1 to number_of_var;
            x[k] = sigma*rand('Normal');
            do j = 1 to rank;
               x[k] = x[k] + A[j]*B[j,k];
            end;
         end;
         output;
      end;
   end;
run;

/* Extract principal components using the RANDOM and EIG methods */

proc pca data=mylib.testdata n=25 method=random(niter=1 seed=6789);
   var x:;
   display Eigenvalues;
   displayout Eigenvalues=oneiter;
run;

proc pca data=mylib.testdata n=25 method=random(niter=5 seed=6789);
   var x:;
   display Eigenvalues;
   displayout Eigenvalues=fiveiter;
run;

proc pca data=mylib.testdata n=25 method=random(niter=10 seed=6789);
   var x:;
   display Eigenvalues;
   displayout Eigenvalues=teniter;
run;

proc pca data=mylib.testdata n=25 method=eig;
   var x:;
   display Eigenvalues;
   displayout Eigenvalues=trueeig;
run;

/* merge data sets */

data mylib.summary;
   keep Number Eig Eig1 Eig5 Eig10;
   merge mylib.oneiter(rename=(Eigenvalue=Eig1))
         mylib.fiveiter(rename=(Eigenvalue=Eig5))
         mylib.teniter(rename=(Eigenvalue=Eig10))
         mylib.trueeig(rename=(Eigenvalue=Eig));
   Number=_N_;
   label Eig1="Eigenvalue";
   label Eig5="Eigenvalue";
   label Eig10="Eigenvalue";
   label Eig="Eigenvalue";
   label Number="Principal Component";
run;

/* Plot eigenvalues for varying number of iterations */
title 'Effect of Varying NITER';

proc sgplot data=mylib.summary;
   series y=Eig1 x=Number / markers legendlabel='1 Iteration';
   series y=Eig5 x=Number / markers legendlabel='5 Iterations';
   series y=Eig10 x=Number / markers legendlabel='10 Iterations';
   series y=Eig x=Number / markers legendlabel='True Eigenvalues';
   xaxis grid min=1 max=25;
   yaxis grid min=30 max=60;
run;

