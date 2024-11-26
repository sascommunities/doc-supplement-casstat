/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NMFGS                                               */
/*   TITLE: Getting Started Example for PROC NMF                */
/* PRODUCT: AASTATISTICS                                        */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multivariate Analysis                               */
/*   PROCS: NMF                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC NMF, Getting Started Example                   */
/*    MISC:                                                     */
/****************************************************************/

title 'Getting Started: Nonnegative Matrix Factorization';

proc contents data=sashelp.JunkMail varnum;
   ods select position;
run;

data mylib.emails;
   set sashelp.JunkMail;
   drop test class capavg caplong captotal;
run;

proc nmf data=mylib.emails seed=789 rank=5 outh=mylib.H;
   output out=mylib.W;
run;

proc transpose data=mylib.H out=H2 name=Term prefix=Topic;
   id _Index_;
run;

%macro Top(din, rank, k, dout);
   %do i = 1 %to &rank;
      data b; set &din;
         keep Term Topic&i;
      proc sort data=b;
         by descending Topic&i;
      run;
      %if (&i = 1) %then %do;
         data &dout; merge b(obs=&k keep=Term);
            rename Term=Topic&i;
         run;
         %end;
      %else %do;
         data &dout; merge &dout b(obs=&k keep=Term);
            rename Term=Topic&i;
         run;
      %end;
   %end;
%mend;

%Top(H2, 5, 10, topics);

proc print data=topics;
run;

