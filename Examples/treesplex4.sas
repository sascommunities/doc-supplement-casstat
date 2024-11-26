/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREESPLEX4                                          */
/*   TITLE: Documentation Example 4 for PROC TREESPLIT          */
/*    DESC: Predicting mortgage default                         */
/*                                                              */
/* PRODUCT: VIYASTAT                                            */
/*  SYSTEM:                                                     */
/*    KEYS:                                                     */
/*   PROCS: TREESPLIT                                           */
/*                                                              */
/****************************************************************/

/* Convert variable names to mixed case */
data mylib.hmeq;
   length Bad Loan MortDue Value 8 Reason Job $7
          YoJ Derog Delinq CLAge nInq CLNo DebtInc 8;
   set sampsio.hmeq;
run;

proc print data=mylib.hmeq(obs=10); run;

ods graphics on;

proc treesplit data=mylib.hmeq maxdepth=5;
   class Bad Delinq Derog Job nInq Reason;
   model Bad = Delinq Derog Job nInq Reason CLAge CLNo
               DebtInc Loan MortDue Value YoJ;
   prune costcomplexity;
   partition fraction(validate=0.3 seed=123);
   * Delete this comment and modify the file name as needed to run:
   code file='treesplexc.sas';
run;

/* Uncomment and modify the file name as needed to run:
data scored;
   set sampsio.hmeq;
   %include 'treesplexc.sas';
run;
*/

