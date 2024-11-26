/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bartex1                                             */
/*   TITLE: Example 2 for PROC BART                             */
/*    DESC: Probit BART model                                   */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: BART, binary data, probit model                     */
/*   PROCS: BART                                                */
/*    DATA: Junk email data set                                 */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data mylib.JunkMail;
   set Sashelp.JunkMail;
run;

proc bart data=mylib.JunkMail seed=210124;
   model Class = Make Address All _3d Our Over Remove
         Internet Order Mail Receive Will People Report Addresses Free Business
         Email You Credit Your Font _000 Money HP HPL George _650 Lab Labs
         Telnet _857 Data _415 _85 Technology _1999 Parts PM Direct CS Meeting
         Original Project RE Edu Table Conference Semicolon Paren Bracket
         Exclamation Dollar Pound CapAvg CapLong CapTotal
   / dist=binary;
   partition rolevar=Test(train='0' test='1');
run;

