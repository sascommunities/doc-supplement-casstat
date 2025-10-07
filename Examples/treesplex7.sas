/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREESPLEX7                                          */
/*   TITLE: Documentation Example 6 for PROC TREESPLIT          */
/*    DESC: Autotuning on HMEQ data                             */
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
   autotune
      /* Tuning Parameters
      You do not need to specify any tuning parameters for the default
      tuning process. If you want to make adjustments to the default
      tuning process, uncomment the following block of code and change
      any of the tuning parameters' attributes.

      tuningParameters=(
         CRITERION   ( values=GAIN GINI GAINRATIO
                  CHAID CHISQUARE init=GAINRATIO  )
         NUMBIN      ( lb=20    ub=200   init=20  )
         MAXDEPTH    ( lb=1     ub=19    init=10  )
         MINLEAFSIZE ( values=1 5 10 20 40 80 160 320 init=5 EXCLUDE  )
      )
      */
   ;
   ods select BestConfiguration; /* Remove this line to see all results */
run;


