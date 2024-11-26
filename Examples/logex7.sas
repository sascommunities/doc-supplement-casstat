/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: logex7                                              */
/*   TITLE: Example 7 for PROC LOGSELECT                        */
/*    DESC: Restoring a Stored Model                            */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binary response data                                */
/*   PROCS: LOGSELECT                                           */
/*    DATA: Junk Email data set                                 */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 7: Restoring a Stored Model
*****************************************************************/

/*
The Sashelp.JunkMail data set comes from a study that classifies
whether an email is junk email (coded as 1) or not (coded as 0).
The data were collected by Hewlett-Packard Labs and donated by
George Forman. The data set, which is specified in the following
DATA step, contains 4,601 observations, with 2 binary variables and
57 continuous explanatory variables. The response variable, Class,
is a binary indicator of whether an email is considered spam or
not. The partitioning variable, Test, is a binary indicator that is
used to divide the data into training and testing sets.  The 57
explanatory variables are continuous variables that represent
frequencies of some common words and characters and lengths of
uninterrupted sequences of capital letters in emails.
*/

title 'Example 7: Restoring a Stored Model';

data mylib.JunkMail;
   set Sashelp.JunkMail;
run;

proc logselect data=mylib.JunkMail;
   model Class(event='1')=Make Address All _3d Our Over Remove Internet Order
         Mail Receive Will People Report Addresses Free Business Email You
         Credit Your Font _000 Money HP HPL George _650 Lab Labs Telnet _857
         Data _415 _85 Technology _1999 Parts PM Direct CS Meeting Original
         Project RE Edu Table Conference Semicolon Paren Bracket Exclamation
         Dollar Pound CapAvg CapLong CapTotal;
   display / excludeall;
   selection method=forward(maxstep=5);
   store mylib.mymodel /
         note="Generated with stepwise selection.";
run;

proc logselect restore=mylib.mymodel stb clb corrb covb type3;
   code;
   oddsratio;
run;

proc logselect restore=mylib.mymodel data=mylib.JunkMail
   association ctable(cutpt=0.1 to 0.9 by 0.1) lackfit partfit;
   output out=mylib.out p cbar;
proc print data=mylib.out(obs=1);
run;

proc logselect restore=mylib.mymodel data=mylib.JunkMail fitdata;
   output out=mylib.out p cbar;
proc print data=mylib.out(obs=1);
run;

