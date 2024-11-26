/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cardinality_ex3                                     */
/*   TITLE: Example 3 for PROC CARDINALITY                      */
/*    DESC: More Levels of the Sepal Length Variable            */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: CARDINALITY                                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mylib.iris;
   set sashelp.iris;
run;

proc cardinality data=mylib.iris (where=(SepalLength > 47))
                 outcard=mylib.card outdetails=mylib.details maxlevels=5;
   var SepalLength;
run;

data sp;
   set mylib.details;
   label _cfmt_='Formatted Value of the Variable SepalLength > 47';
   if _index_ = . then do;
      _cfmt_=cats(">",left(_cfmt_));
   end;
  _cfmt_=left(_cfmt_);
run;

proc sgplot data=sp;
   vbar _cfmt_ / freq=_freq_;
run;

proc cardinality data=mylib.iris outcard=mylib.card
                 outdetails=mylib.details maxlevels=5;
run;

proc print data=mylib.card;
   var _varname_ _mf:;
run;

