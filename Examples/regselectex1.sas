/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regselectex1                                        */
/*   TITLE: Example 1 for PROC REGSELECT                        */
/*    DESC: Simulated Data                                      */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, Validation                         */
/*   PROCS: REGSELECT                                           */
/*                                                              */
/****************************************************************/

%let nTotalObs=15000;
%let seed=1;
   data mylib.analysisData;
    drop i j c3Num nObsPerThread nExtras rew;
    length c3$ 7;

    array x{20} x1-x20;
    call streamInit(&seed);
    nObsPerThread  = int(&nTotalObs/_nthreads_);
    nExtras        = mod(&nTotalObs,_nthreads_);
    if _threadid_ <= nExtras then nObsPerThread =  nObsPerThread + 1;

    do i=1 to nObsPerThread;
       id = (_threadid_-1)*nObsPerThread +i;
       if _threadid_ > nExtras then id=id+nExtras;
       rew = rand('rewind', id);

       do j=1 to 20;
          x{j} = rand('UNIFORM');
       end;

       if  rand('UNIFORM') < 0.4 then byVar='A';
       else                           byVar='B';

       c1 = 1 + mod(id,8);
       c2 = rand('BERNOULLI',0.6);

       if      id < (0.001 * &nTotalObs) then do; c3 = 'tiny';     c3Num=1;end;
       else if id < (0.3   * &nTotalObs) then do; c3 = 'small';    c3Num=1;end;
       else if id < (0.7   * &nTotalObs) then do; c3 = 'average';  c3Num=2;end;
       else if id < (0.9   * &nTotalObs) then do; c3 = 'big';      c3Num=3;end;
       else                                   do; c3 = 'huge';     c3Num=5;end;

       yTrue = 10 + x1 + 2*x5 + 3*x10 + 4*x20  + 3*x1*x7 + 8*x6*x7
                  + 5*c3Num   + 8*(c1=7) + 8*(c1=3)*c2;
       error = 5*rand('NORMAL');
       y = yTrue + error;

            if mod(id,3)=1 then Role = 'TRAIN';
       else if mod(id,3)=2 then Role = 'VAL';
       else                     Role = 'TEST';

       output;
    end;
   run;

data work.analysisData;
   set mylib.analysisData;
run;
proc summary data=work.analysisData;
   class role;
   ways 1;
   var error;
   output out=ASE uss=uss n=n;
data ASE; set ASE;
   OracleASE = uss / n;
   label OracleASE = 'Oracle ASE';
   keep Role OracleASE;
run;

proc print data=ASE label noobs;
run;

ods graphics on;
proc regselect data=mylib.analysisData;
   partition roleVar=role(train='TRAIN' validate='VAL' test='TEST');
   class c1 c2 c3;
   model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
              |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2 /stb;
   selection method = stepwise(select=sl sle=0.1 sls=0.15 choose=validate)
                       hierarchy=single details=steps plots(startstep=5)=all;
run;

proc regselect data=mylib.analysisData;
   partition roleVar=role(train='TRAIN' validate='VAL' test='TEST');
   class c1(split) c2 c3;
   model y = c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
             |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2 /stb;
   selection method = stepwise(select=sl sle=0.1 sls=0.15 choose=validate)
             hierarchy=single details=steps;
run;

