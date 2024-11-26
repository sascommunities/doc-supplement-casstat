/********************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                     */
/*                                                                  */
/*    NAME: varreduce_ex3.sas                                       */
/*   TITLE: Example 3 for PROC VARREDUCE                            */
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

data mylib.data2;
   array x{2};
   do i=1 to 2000;
      a=int(ranuni(1)*2);
      do j=1 to 2;
         x{j}=ranuni(1);
      end;
      output;
   end;
run;

title  "Output the Correlation Matrix in LIL Format";

proc varreduce data=mylib.data2 matrix=corr outcp=mylib.corr_lil/list eps=0.01;
   class a;
   reduce unsupervised a x1-x2 /maxsteps=4;
run;

proc print data=mylib.corr_lil;
run;

