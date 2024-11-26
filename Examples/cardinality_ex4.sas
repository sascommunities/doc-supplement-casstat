/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cardinality_ex4                                     */
/*   TITLE: Example 4 for PROC CARDINALITY                      */
/*    DESC: A Variable with a User-Defined Format               */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: CARDINALITY                                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mylib.cars;
   set sashelp.cars;
run;

proc format casfmtlib='myfmtlib';
   value engsize
       low - <3 ='toys'
       3   - <6 ='granny'
       6   -high='usable';
run;

data mylib.cars;
   format engineSize engsize.;
   set mylib.cars;
run;

proc cardinality data=mylib.cars outcard=mylib.card
                 outdetails=mylib.details maxlevels=5;
   var engineSize;
run;

title 'Cars data with a user-defined format';
proc print data=mylib.card;
   var _varname_ _order_ _more_ _cardinality_;
run;

proc print data=mylib.details;
   var _varname_ _index_ _freq_ _cfmt_;
run;

