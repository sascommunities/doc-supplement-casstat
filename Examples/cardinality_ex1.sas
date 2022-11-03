/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cardinality_ex1                                     */
/*   TITLE: Example 1 for PROC CARDINALITY                      */
/*    DESC: Limited Cardinality of the Species Variable         */
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

proc cardinality data=mycas.iris outcard=mycas.card
                 outdetails=mycas.details maxlevels=5;
run;

data sp;
   set mycas.details( where=(_varname_='Species'));
   label _cfmt_='Formatted value of the variable Species';
   if _index_ = . then do;
      _cfmt_=cats(">",left(_cfmt_));
   end;
  _cfmt_=left(_cfmt_);
run;

proc sgplot data=sp;
  vbar _cfmt_ / freq=_freq_;
run;

