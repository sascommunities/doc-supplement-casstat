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

data mycas.iris;
   set sashelp.iris;
run;

proc cardinality data=mycas.iris (where=(SepalLength > 47))
                 outcard=mycas.card outdetails=mycas.details maxlevels=5;
   var SepalLength;
run;

data sp;
   set mycas.details;
   label _cfmt_='Formatted Value of the Variable SepalLength > 47';
   if _index_ = . then do;
      _cfmt_=cats(">",left(_cfmt_));
   end;
  _cfmt_=left(_cfmt_);
run;

proc sgplot data=sp;
   vbar _cfmt_ / freq=_freq_;
run;

proc cardinality data=mycas.iris outcard=mycas.card
                 outdetails=mycas.details maxlevels=5;
run;

proc print data=mycas.card;
   var _varname_ _mf:;
run;

