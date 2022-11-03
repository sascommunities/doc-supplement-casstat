/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: kclus_gs.sas                                        */
/*   TITLE: Getting Started Example for PROC KCLUS              */
/*    DESC:                                                     */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: KCLUS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data mycas.inpData;
   title 'Using PROC KCLUS to Analyze Data';
   drop n;
   id=1;
   do n=1 to 1000;
      x=2*rannor(12345)+20;
      y=4*rannor(12345)+20;
      freq = 1;
      id = id + 1;
      output;
   end;
   do n=1 to 1000;
      x=3*rannor(12345)+10;
      y=5*rannor(12345)+10;
      freq=2;
      id = id + 1;
      output;
   end;
   do n=1 to 700;
      x=10*rannor(12345);
      y=10*rannor(12345);
      freq=1;
      id = id + 1;
      output;
   end;
   do n=1 to 200;
      x=.;
      y=10*rannor(12345);
      freq=1;
      id = id + 1;
      output;
   end;
run;

proc kclus data=mycas.inpData maxclusters=3;
   input x y;
   freq freq;
run;

