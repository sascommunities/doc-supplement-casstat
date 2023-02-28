/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: assess_ex1                                          */
/*   TITLE: Example 1 for PROC ASSESS                           */
/*    DESC: Assess a Model with Two Levels  in Target           */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ASSESS                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data mycas.score2;
   length good_bad $4;
   input _PartInd_ good_bad p_good p_bad;
   datalines;
0 good 0.6675 0.3325
0 good 0.5189 0.4811
0 good 0.6852 0.3148
0 bad  0.0615 0.9385
0 bad  0.3053 0.6947
0 bad  0.6684 0.3316
0 good 0.6422 0.3578
0 good 0.6752 0.3248
0 good 0.5396 0.4604
0 good 0.4983 0.5017
0 bad  0.1916 0.8084
0 good 0.5722 0.4278
0 good 0.7099 0.2901
0 good 0.4642 0.5358
0 good 0.4863 0.5137
1 bad  0.4942 0.5058
1 bad  0.4863 0.5137
1 bad  0.4942 0.5058
1 good 0.6118 0.3882
1 good 0.5375 0.4625
1 good 0.8132 0.1868
1 good 0.6914 0.3086
1 good 0.5700 0.4300
1 good 0.8189 0.1811
1 good 0.2614 0.7386
1 good 0.1910 0.8090
1 good 0.5129 0.4871
1 good 0.8417 0.1583
1 good 0.5500 0.4500
;

proc assess data=mycas.score2 ncuts=5 nbins=5;
   var p_good;
   target good_bad / event="good" level=nominal;
   fitstat pvar=p_bad / pevent="bad" ;
   by _PartInd_;
run;

