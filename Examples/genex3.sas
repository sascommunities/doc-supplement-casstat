/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: genex3                                              */
/*   TITLE: Example 3 for PROC GENSELECT                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Binary regression analysis, GEE                     */
/*   PROCS: GENSELECT                                           */
/*    DATA: Six Cities                                          */
/*                                                              */
/*     REF: SAS Visual Statistics Procedures, GENSELECT chapter */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 3: Binary regression with repeated measures
*****************************************************************/

/*
The data comes from the 'Six Cities' study (Ware et al. 1984).
The example fits a repeated measures model using generalized
estimating equations.
*/

title 'Example 3: Binary Regression with Repeated Measures';

data mycas.six;
     input case city$ @@;
   do i=1 to 4;
      input age smoke wheeze @@;
      output;
   end;
   datalines;
 1 portage   9 0 1  10 0 1  11 0 1  12 0 0
 2 kingston  9 1 1  10 2 1  11 2 0  12 2 0
 3 kingston  9 0 1  10 0 0  11 1 0  12 1 0
 4 portage   9 0 0  10 0 1  11 0 1  12 1 0
 5 kingston  9 0 0  10 1 0  11 1 0  12 1 0
 6 portage   9 0 0  10 1 0  11 1 0  12 1 0
 7 kingston  9 1 0  10 1 0  11 0 0  12 0 0
 8 portage   9 1 0  10 1 0  11 1 0  12 2 0
 9 portage   9 2 1  10 2 0  11 1 0  12 1 0
10 kingston  9 0 0  10 0 0  11 0 0  12 1 0
11 kingston  9 1 1  10 0 0  11 0 1  12 0 1
12 portage   9 1 0  10 0 0  11 0 0  12 0 0
13 kingston  9 1 0  10 0 1  11 1 1  12 1 1
14 portage   9 1 0  10 2 0  11 1 0  12 2 1
15 kingston  9 1 0  10 1 0  11 1 0  12 2 1
16 portage   9 1 1  10 1 1  11 2 0  12 1 0
;

proc genselect data=mycas.six;
   class case city;
   model wheeze(event='1') = city age smoke / dist=binary;
   repeated subject=case / type=exch covb corrw printmle;
run;

