/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: efaex1                                              */
/*   TITLE: Example 1 for PROC EFA                              */
/*    DESC: Number of factors determination                     */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: EFA, factor analysis, number of factors             */
/*   PROCS: EFA                                                 */
/*    DATA: simulated                                           */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/* Uses the simulated testdata data set from the Principal      */
/* Component Analysis Action Set documentation.                 */
/*                                                              */
/****************************************************************/

data mylib.testdata;
   keep x:;
   drop rank number_of_obs number_of_var sigma ii idum;
   drop rv1 rv2 rsq fac row col;
   drop nobs_per_thread nextras start_obs obs j k;
   array B[4,10];       /* dimensions: rank, number_of_var */
   array A[4];          /* dimension: rank */
   array x[10] x1-x10;  /* dimension: number_of_var */

   rank=4;
   number_of_obs=1000000;
   number_of_var=10;
   sigma=0.1;

   call streaminit(1);

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

   nobs_per_thread = int(number_of_obs /_nthreads_);
   nextras = number_of_obs - nobs_per_thread*_nthreads_;
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
run;


proc efa data=mylib.testdata method=none;
   nfactors type=eigenvalue;
   nfactors type=proportion threshold=0.9;
run;

proc efa data=mylib.testdata method=none priors=one;
   nfactors type=proportion threshold=0.90;
   nfactors type=proportion threshold=0.95;
   nfactors type=proportion threshold=0.99;
run;

