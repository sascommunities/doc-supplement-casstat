/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREESPLEX6                                          */
/*   TITLE: Documentation Example 6 for PROC TREESPLIT          */
/*    DESC: Mitigate bias for mortgage data                     */
/*     REF: None                                                */
/*                                                              */
/* PRODUCT: VIYASTAT                                            */
/*  SYSTEM:                                                     */
/*    KEYS:                                                     */
/*   PROCS: TREESPLIT                                           */
/*                                                              */
/****************************************************************/

data mylib.hmeq;
   set sampsio.hmeq;
run;

proc treesplit data=mylib.hmeq;
   class Bad Reason;
   model Bad = CLAge CLNo DebtInc Derog
               Loan MortDue Reason Value;
   prune off;
   output out=mylib.scored copyvars=(_ALL_);
   saveState rstore=mylib.treeModel;
run;

proc assessbias data=mylib.scored;
   target bad / event="1" level=nominal;
   var P_Bad1;
   fitstat pvar=P_BAD0 / pevent="0";
   sensitiveVar Job;
run;

proc astore;
   describe rstore=mylib.treeModel;
run;

ods graphics on;

proc treesplit data=mylib.hmeq;
   class Bad Reason;
   model Bad = CLAge CLNo DebtInc Derog
               Loan MortDue Reason Value;
   prune off;
   saveState rstore=mylib.treeModel;
   mitigateBias pevents="1 0"
                pvars=(P_BAD1 P_BAD0)
                seed=12345
                sensitivevar=Job
                targetEvent="1";
run;

