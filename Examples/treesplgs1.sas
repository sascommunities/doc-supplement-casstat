/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREESPLGS1                                          */
/*   TITLE: Getting Started Example for PROC TREESPLIT          */
/*    DESC: Iris Species                                        */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Classification Trees                                */
/*   PROCS: TREESPLIT                                           */
/*                                                              */
/****************************************************************/

data Wine;
   %let url = http://archive.ics.uci.edu/ml/machine-learning-databases;
   infile "&url/wine/wine.data" url delimiter=',';
   input Cultivar Alcohol Malic Ash Alkan Mg TotPhen
         Flav NFPhen Cyanins Color Hue ODRatio Proline;
   label Cultivar = "Cultivar"
         Alcohol  = "Alcohol"
         Malic    = "Malic Acid"
         Ash      = "Ash"
         Alkan    = "Alkalinity of Ash"
         Mg       = "Magnesium"
         TotPhen  = "Total Phenols"
         Flav     = "Flavonoids"
         NFPhen   = "Nonflavonoid Phenols"
         Cyanins  = "Proanthocyanins"
         Color    = "Color Intensity"
         Hue      = "Hue"
         ODRatio  = "OD280/OD315 of Diluted Wines"
         Proline  = "Proline";
run;

data mycas.Wine;
   set Wine;
run;

proc print data=Wine(obs=10); run;

ods graphics on;

proc treesplit data=mycas.Wine seed=54321;
   class Cultivar;
   model Cultivar = Alcohol Malic Ash Alkan Mg TotPhen Flav
                              NFPhen Cyanins Color Hue ODRatio Proline;
   grow entropy;
   prune costcomplexity(leaves=SE);
run;

