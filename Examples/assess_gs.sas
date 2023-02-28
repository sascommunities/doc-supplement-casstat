/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: assess_gs                                           */
/*   TITLE: Getting Started Example for PROC ASSESS             */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ASSESS                                              */
/*    DATA:                                                     */                                                            */
/*     REF:                                                     */
/*    MISC: Example from the Getting Started section of the     */
/*          ASSESS                                              */
/****************************************************************/

data mycas.score;
   input _PartInd_ good p_good;
   datalines;
0 0.8224 0.7590
0 0.6538 0.4632
0 0.7693 0.7069
0 0.7491 0.7087
0 0.7779 0.7209
1 0.7161 0.8389
1 0.6779 0.6209
1 0.6392 0.6077
1 0.8090 0.9096
1 0.6064 0.7355
;

proc assess data=mycas.score nbins=2;
   var p_good;
   target good;
   by _PartInd_;
run;

