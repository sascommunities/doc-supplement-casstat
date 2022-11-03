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

data mycas.iris;
   set sashelp.iris;
run;


proc cardinality data=mycas.iris outcard=mycas.card
                 outdetails=mycas.details maxlevels=10;
run;

proc print data=mycas.card;
   var _varname_ _type_ _cardinality_ _more_;
run;

data details;
   set mycas.details;
   where _varname_ in ('Species', 'SepalLength');
run;

proc print data=details;
   var _VARNAME_ _INDEX_ _FREQ_ _RAWNUM_ _RAWCHAR_;
run;

