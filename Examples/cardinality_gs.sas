/***************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                */
/*                                                             */
/*    NAME: cardinality_gs                                     */
/*   TITLE: Getting Started Example for PROC CARDINALITY       */
/* PRODUCT: AACAS                                              */
/*  SYSTEM: ALL                                                */
/*    KEYS:                                                    */
/*   PROCS: CARDINALITY                                        */
/*    DATA:                                                    */
/*                                                             */
/*     REF:                                                    */
/*    MISC: Example from the Getting Started section of the    */
/*          CARDINALITY chapter.                               */
/*                                                             */
/***************************************************************/

data mylib.iris;
   set sashelp.iris;
run;


proc cardinality data=mylib.iris outcard=mylib.card
                 outdetails=mylib.details maxlevels=10;
run;

proc print data=mylib.card;
   var _varname_ _type_ _cardinality_ _more_;
run;

data details;
   set mylib.details;
   where _varname_ in ('Species', 'SepalLength');
run;

proc print data=details;
   var _VARNAME_ _INDEX_ _FREQ_ _RAWNUM_ _RAWCHAR_;
run;

