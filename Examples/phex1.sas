/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: phex1                                              */
/*   TITLE: Example 1 for PROC PHSELECT                         */
/*    DESC: Model Selection                                     */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Cox regression analysis,                            */
/*          Binary response data                                */
/*          Forward selection                                  */
/*   PROCS: PHSELECT                                            */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 1: Model Selection
*****************************************************************/

/*
The data, from the Getting Started example (coxgs1), consists of
100 observations on a dichotomous response variable y, a character
variable C, and 10 continuous variables x1--x10.  A forward
selection technique is used to select the variables for use in a
main effects cox regression model of these data.
*/

title 'Example 1: Model Selection';

data mycas.getStarted;
   input Time Status C1$ C2 C3$ X1-X4;
   datalines;
53       0      Low          1    M     1.11    2.000    3.6128    12.0
12       0      High         1    M     1.40    1.362    3.8388     8.8
11       1      Low          1    F     1.57    1.672    3.8865     7.5
 7       1      Medium       0    M     1.04    2.000    3.7324     5.1
 2       1      Low          1    M     1.52    2.000    3.8751     9.8
41       0      High         1    M     1.76    1.447    3.7243    12.8
 6       1      Critical     1    F     1.36    1.462    3.5441     9.0
 6       1      Critical     1    M     1.42    1.690    3.9294    10.4
16       1      Medium       1    M     1.32    0.699    3.6990     8.8
41       1      Medium       1    M     1.00    1.477    3.4771    10.2
 2       1      High         0    M     1.30    2.000    3.7243     5.1
58       1      Medium       1    M     1.20    1.580    3.6990    12.1
11       1      High         1    M     1.08    1.903    3.5051     9.6
12       0      Critical     1    F     1.15    1.146    3.6435    11.6
16       0      High         1    F     1.15    0.903    3.8573    13.0
54       1      Medium       1    M     1.26    1.699    3.7243     9.0
51       1      Low          0    M     1.57    1.041    3.4150     7.7
67       1      Medium       1    M     1.32    1.041    3.6435    12.8
 1       1      Low          1    M     1.94    1.954    3.9868    12.0
19       0      Medium       1    M     1.32    2.000    3.7709    13.0
 1       1      Medium       1    M     2.22    1.954    3.6628     9.4
35       1      Medium       0    M     1.11    1.176    3.6532     7.0
41       1      High         1    M     1.15    1.342    3.5185     5.0
58       1      Medium       1    M     1.20    1.580    3.6990    12.1
11       1      Medium       1    M     1.11    1.279    3.8808    14.0
41       1      Medium       1    M     1.00    1.477    3.4771    10.2
19       1      High         0    M     1.26    1.929    3.7924     7.5
89       1      High         1    M     1.32    1.623    3.6532    14.0
 4       0      Medium       1    F     1.95    0.778    4.0453    10.2
 6       1      Critical     1    F     1.36    1.462    3.5441     9.0
57       0      Low          1    F     1.26    1.954    3.9685    12.5
 5       1      High         1    M     2.24    1.663    4.9542    10.1
17       1      Medium       1    F     1.59    1.613    3.4314    11.2
77       0      Low          1    F     1.08    0.954    3.6812    14.0
66       1      High         1    M     1.45    1.820    3.7853     6.6
16       1      Medium       1    M     1.32    0.699    3.6990     8.8
 8       0      Critical     1    M     1.08    1.653    3.8325     9.9
19       1      High         0    M     1.26    1.929    3.7924     7.5
37       1      High         1    F     1.60    1.204    3.9542    11.0
52       1      Medium       1    M     1.00    1.653    3.8573    10.1
13       0      High         0    F     1.66    1.792    3.6435     4.9
 3       1      Medium       1    F     1.54    1.935    4.4757     6.7
51       1      Low          0    M     1.57    1.041    3.4150     7.7
 2       1      High         0    M     1.30    2.000    3.7243     5.1
25       1      Medium       1    M     1.00    1.644    3.8195    12.4
11       1      Low          1    F     1.57    1.672    3.8865     7.5
19       1      Low          1    M     1.08    2.000    3.9191    14.4
 9       1      Low          1    M     1.72    1.740    3.7993     8.2
 6       1      Medium       1    M     1.11    1.398    3.5185     9.7
16       1      Medium       1    M     1.34    2.000    3.9345     9.0
12       0      High         1    M     1.40    1.362    3.8388     8.8
17       1      High         1    M     1.23    1.447    3.8808    10.0
17       1      High         1    M     1.23    1.447    3.8808    10.0
41       0      High         1    M     1.76    1.447    3.7243    12.8
88       1      High         1    F     1.18    1.756    3.5563    10.6
16       0      High         1    F     1.15    0.903    3.8573    13.0
 4       0      Low          1    F     1.92    1.623    3.9590    10.0
 7       1      Low          1    M     1.18    1.519    3.7243    11.4
19       0      Medium       1    M     1.32    1.519    3.8808    10.8
 8       0      Critical     1    M     1.08    1.653    3.8325     9.9
57       0      Low          1    F     1.26    1.954    3.9685    12.5
 7       1      Medium       1    M     1.98    1.568    3.3617     9.5
19       1      Low          1    M     1.08    2.000    3.9191    14.4
 7       0      Low          1    F     1.53    1.881    3.5911    10.2
 5       1      High         1    F     1.68    1.732    3.7324     6.5
 2       1      Low          0    M     1.75    1.255    3.8062    11.3
 1       1      Low          1    M     1.94    1.954    3.9868    12.0
15       1      Low          1    M     1.60    1.431    3.6902    10.6
26       1      Low          1    M     1.23    2.000    3.6021    11.2
92       1      Low          1    M     1.43    1.415    4.0755    11.0
11       1      Medium       1    M     1.30    1.820    3.7993    13.2
 3       1      Medium       1    F     1.54    1.935    4.4757     6.7
66       1      High         1    M     1.45    1.820    3.7853     6.6
 1       1      Medium       1    M     2.22    1.954    3.6628     9.4
11       1      Medium       1    M     1.30    1.820    3.7993    13.2
14       1      Medium       1    M     1.40    1.255    3.7243    14.6
32       1      High         1    M     1.32    1.634    3.6990    10.6
24       1      High         1    M     1.30    0.477    4.0899    14.6
18       1      Critical     1    F     1.45    0.903    3.5682     7.5
 5       1      High         1    F     1.68    1.732    3.7324     6.5
 2       1      Low          0    M     1.75    1.255    3.8062    11.3
26       1      Low          1    M     1.23    2.000    3.6021    11.2
11       1      High         1    M     1.23    1.176    3.7709    12.0
28       0      High         1    M     1.23    1.672    3.7482     7.3
19       0      Medium       1    M     1.32    2.000    3.7709    13.0
54       1      Medium       1    M     1.26    1.699    3.7243     9.0
 2       1      Low          1    M     1.52    2.000    3.8751     9.8
 7       0      Medium       1    M     1.11    1.857    3.7993    12.4
19       0      Medium       1    M     1.32    1.519    3.8808    10.8
 6       1      Critical     1    M     1.42    1.690    3.9294    10.4
 6       1      Medium       1    M     1.11    1.398    3.5185     9.7
11       1      Medium       1    M     1.11    1.279    3.8808    14.0
 6       1      Critical     0    M     2.11    1.362    3.5441    10.2
13       1      Medium       0    M     0.78    1.398    3.5798     5.5
18       1      Critical     1    F     1.45    0.903    3.5682     7.5
 7       0      Low          1    F     1.53    1.881    3.5911    10.2
53       0      Low          1    M     1.11    2.000    3.6128    12.0
11       1      High         1    M     1.08    1.903    3.5051     9.6
11       0      High         1    M     1.61    1.845    3.7324    14.0
89       1      High         1    M     1.32    1.623    3.6532    14.0
;

ods graphics on;

proc phselect data=mycas.getStarted;
   class C1-C3;
   model Time*Status(0) = C1-C3 X1-X4;
   selection method=forward(stop=sbc select=sbc) details=all plots=all;
run;

