/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamselex1                                           */
/*   TITLE: Example 1 for PROC GAMSELECT                        */
/*    DESC: Partitioning Data, Binary Data                      */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binary response data, boosting                      */
/*   PROCS: GAMSELECT                                           */
/*    DATA: Junk Email data set                                 */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data mylib.JunkMail;
   set Sashelp.JunkMail;
run;

%macro SplineVList(vars);
   %let i = 1;
   %do %while (%length(%scan(&vars,&i)));
      spline(%scan(&vars,&i))
      %let i = %eval(&i + 1);
   %end;
%mend;

proc gamselect data=mylib.JunkMail;
   model Class(event='1')= %SplineVList(Make Address All _3d Our Over Remove
         Internet Order Mail Receive Will People Report Addresses Free Business
         Email You Credit Your Font _000 Money HP HPL George _650 Lab Labs
         Telnet _857 Data _415 _85 Technology _1999 Parts PM Direct CS Meeting
         Original Project RE Edu Table Conference Semicolon Paren Bracket
         Exclamation Dollar Pound CapAvg CapLong CapTotal)
   / dist=binary allobs;
   partition rolevar=Test(train='0' test='1');
   selection method=boosting(maxIter=2000);
run;

proc logselect data=mylib.JunkMail;
   model Class(event='1')=Make Address All _3d Our Over Remove Internet Order
         Mail Receive Will People Report Addresses Free Business Email You
         Credit Your Font _000 Money HP HPL George _650 Lab Labs Telnet _857
         Data _415 _85 Technology _1999 Parts PM Direct CS Meeting Original
         Project RE Edu Table Conference Semicolon Paren Bracket Exclamation
         Dollar Pound CapAvg CapLong CapTotal;
   partition rolevar=Test(train='0' test='1');
   selection method=forward;
run;

