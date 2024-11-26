/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: logex8                                              */
/*   TITLE: Example 8 for PROC LOGSELECT                        */
/*    DESC: Modeling Microarray Data                            */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binary response data, elastic net selection         */
/*   PROCS: LOGSELECT                                           */
/*    DATA: leukemia data set (Golub et al. 1999)               */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 8: Modeling Microarray Data
*****************************************************************/

/*
The Sashelp.LeuTrain and Sashelp.LeuTest data sets come from a
cancer study that classifies whether a patient has type 1 leukemia
(acute lymphoblastic leukemia) or type 2 leukemia (acute myeloid
leukemia). The Sashelp.LeuTrain data set contains 38 samples for
model training and each sample contains 7129 gene expression
measurements. The Sashelp.LeuTest data set contains 34 samples for 
testing prediction accuracy. The response variable is coded as 1 
for type 1 leukemia, and -1 for type 2 leukemia.
*/

title 'Example 8: Modeling Microarray Data with Elastic Net';

data LeuTrain;
   set Sashelp.LeuTrain;
   call streamInit(123);
   if rand('UNIFORM')<0.6 then role='train'; else role='valid';
run;
data mylib.LeuTrain;
   set LeuTrain;
run;
data mylib.LeuTest;
   set Sashelp.LeuTest;
run;

proc logselect data=mylib.LeuTrain partfit;
   model y=x1-x7129;
   selection method=elasticnet(choose=validate);
   partition role=role(train='train' validate='valid');
   store mylib.ElasticNetModel / note="Microarray data with Elastic Net.";
run;

proc logselect restore=mylib.ElasticNetModel data=mylib.LeuTest partfit;
run;

