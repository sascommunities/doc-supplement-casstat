/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CORREX2                                             */
/*   TITLE: Documentation Example 6 for PROC CORRELATION        */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: correlation analysis                                */
/*   PROCS: CORRELATION                                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CORRELATION EXAMPLE 2                          */
/*    MISC:                                                     */
/****************************************************************/

*------------------- Fish Measurement Data -----------------------*
| The data table contains 35 fish from the species Bream caught   |
| in Finland's Lake Laengelmavesi with the following measurements:|
| Weight   (in grams)                                             |
| Length3  (length from the nose to the end of the tail, in cm)   |
| HtPct    (max height, as percentage of Length3)                 |
| WidthPct (max width,  as percentage of Length3)                 |
*-----------------------------------------------------------------*;
data mylib.Fish1 (drop=HtPct WidthPct);
   title 'Fish Measurement Data';
   input Weight Length3 HtPct WidthPct @@;
   Weight3= Weight**(1/3);
   Height=HtPct*Length3/100;
   Width=WidthPct*Length3/100;
   datalines;
242.0 30.0 38.4 13.4     290.0 31.2 40.0 13.8
340.0 31.1 39.8 15.1     363.0 33.5 38.0 13.3
430.0 34.0 36.6 15.1     450.0 34.7 39.2 14.2
500.0 34.5 41.1 15.3     390.0 35.0 36.2 13.4
450.0 35.1 39.9 13.8     500.0 36.2 39.3 13.7
475.0 36.2 39.4 14.1     500.0 36.2 39.7 13.3
500.0 36.4 37.8 12.0        .  37.3 37.3 13.6
600.0 37.2 40.2 13.9     600.0 37.2 41.5 15.0
700.0 38.3 38.8 13.8     700.0 38.5 38.8 13.5
610.0 38.6 40.5 13.3     650.0 38.7 37.4 14.8
575.0 39.5 38.3 14.1     685.0 39.2 40.8 13.7
620.0 39.7 39.1 13.3     680.0 40.6 38.1 15.1
700.0 40.5 40.1 13.8     725.0 40.9 40.0 14.8
720.0 40.6 40.3 15.0     714.0 41.5 39.8 14.1
850.0 41.6 40.6 14.9    1000.0 42.6 44.5 15.5
920.0 44.1 40.9 14.3     955.0 44.0 41.1 14.3
925.0 45.3 41.4 14.9     975.0 45.9 40.6 14.7
950.0 46.5 37.9 13.7
;

title 'Fish Measurement Data';
proc correlation data=mylib.fish1 nomiss alpha;
   var Weight3 Length3 Height Width;
run;

