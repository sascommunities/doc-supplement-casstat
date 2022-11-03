/********************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                     */
/*                                                                  */
/*    NAME: varreduce_ex2.sas                                       */
/*   TITLE: Example 2 for PROC VARREDUCE                            */
/*                                                                  */
/* PRODUCT: AACAS                                                   */
/*  SYSTEM: ALL                                                     */
/*    KEYS:                                                         */
/*   PROCS: VARREDUCE                                               */
/*    DATA:                                                         */
/*                                                                  */
/*     REF:                                                         */
/*    MISC:                                                         */
/********************************************************************/

data mycas.data1;
   array x{2};
   array c{2};
   do i=1 to 2000;
      a=int(ranuni(1)*2);
      do j=1 to 2;
         x{j}=ranuni(1);
         c{j}=int(ranuni(1)*2);
      end;
      output;
   end;
run;

title  "Output the Correlation Matrix";

proc varreduce data=mycas.data1 matrix=corr outcp=mycas.corr;
   class a;
   reduce unsupervised a x1-x2 /maxsteps=4;
run;

proc print data=mycas.corr;
run;

