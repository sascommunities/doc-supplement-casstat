/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SANDWICH1                                           */
/*   TITLE: Example 1 for PROC SANDWICH                         */
/*          Analysis of Microarray Data                         */
/* PRODUCT: CASSTAT                                             */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Microarray Data                                     */
/*          Genome                                              */
/*   PROCS: SANDWICH                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SANDWICH, EXAMPLE 1.                           */
/*    MISC:                                                     */
/****************************************************************/

%let nArray  = 6;
%let nDye    = 2;
%let nGene   = 500;
%let nTrt    = 2;

data mycas.microarray;
   keep  Microarray Array Gene Trt Dye Density;
   array GeneDist{&ngene};
   array ArrayEffect{&narray};
   do i = 1 to &nGene;
       GeneDist{i} = 1 + int(&nGene*ranuni(12345));
   end;
   do i = 1 to &nArray;
      ArrayEffect{i} = sqrt(0.014)*rannor(12345);
   end;

   do Microarray = 1 to &nArray;
      do Dye = 1 to &nDye;
         do k = 1 to &nGene;
            Trt   = 1 + int(&nTrt*ranuni(12345));
            Gene  = GeneDist{k};
            Array = ArrayEffect{Microarray};

            Density  = 1 +
                     + Dye
                     + Trt
                     + Gene/1000.0
                     + Gene*Dye/1000.0
                     + Gene*Trt/1000.0
                     + Array
                     + sqrt(0.02)*rannor(12345);
            output;
         end;
      end;
   end;
run;


ods select Dimensions ModelAnova ModelInfo;
proc sandwich data=mycas.microarray sparse;
   class Microarray Gene Trt Dye;
   model Density = Gene Trt Dye Gene*Trt Gene*Dye/ss3;
   cluster Microarray;
run;

