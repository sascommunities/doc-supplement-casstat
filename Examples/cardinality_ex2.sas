/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cardinality_ex2                                     */
/*   TITLE: Example 2 for PROC CARDINALITY                      */
/*    DESC: Limited Cardinality of the Sepal Length Variable    */
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

proc cardinality data=mylib.iris outcard=mylib.card
                 outdetails=mylib.details maxlevels=100;
run;


proc print data=mylib.card;
   var _varname_ _type_ _cardinality_ _more_ _visible_ _min_ _max_;
run;

data sp;
   label _cfmt_='Formatted Value of the Variable \Variable{SepalLength}';
   set mylib.details( where=(_varname_='SepalLength'));
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

data sp;
   label _cfmt_='Formatted Value of the Variable SepalLength';
   set mylib.details( where=(_varname_='SepalLength'));
   if _index_ = . then do;
      _cfmt_=cats(">",left(_cfmt_));
   end;
   _cfmt_=left(_cfmt_);
run;

proc sgplot data=sp;
   vbar _cfmt_ / freq=_freq_;
run;

