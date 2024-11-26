/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: modelmatrixgs                                       */
/*   TITLE: Getting Started Example for PROC MODELMATRIX        */
/*    DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                   */
/*     REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*          Update, Macmillan Publishing Company, New York.     */
/*                                                              */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Design Matrix                                       */
/*   PROCS: MODELMATRIX                                         */
/*                                                              */
/****************************************************************/

proc contents varnum data=sashelp.baseball
(KEEP = League Division nHits yrMajor);
   ods select position;
run;

data mylib.baseball;
   set sashelp.baseball;
   index = _N_;
run;

proc modelmatrix data=mylib.baseball;
  class League Division;
  model logSalary = League Division nHits*yrMajor;
  output out = mylib.designMat copyvar=index;
run;


data designMat;
 set mylib.designMat;
run;

proc sort data=designMat;
 by index;
run;

proc print data = designMat(obs=15 drop=index) label;
label COL1='Intercept'
      COL2='League American'
      COL3='League National'
      COL4='Division East'
      COL5='Division West'
      COL6='nHits * YrMajor';
run;

