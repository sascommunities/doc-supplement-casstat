/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cardinality_ex5                                     */
/*   TITLE: Example 5 for PROC CARDINALITY                      */
/*    DESC: Forcing Another Order on the engineSize Variable    */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: CARDINALITY                                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mycas.cars;
   set sashelp.cars;
run;

title 'Cars data with a user-defined format with an ASC order';
proc cardinality data=mycas.cars outcard=mycas.card
                 outdetails=mycas.details maxlevels=5;
   var engineSize /order=asc;
run;

proc print data=mycas.card ;
   var _varname_ _order_ _more_ _cardinality_;
run;

data details(drop=_rawchar_);
   set mycas.details;
   if _index_ = . then do;
      _cfmt_ = cats(">",  put(_rawnum_,best12.));
      _rawnum_ = .;
   end;
     _cfmt_=left(_cfmt_);
run;

proc print data=details;
run;

