/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX2                                              */
/*   TITLE: Documentation Example 2 for PROC SPC                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Process Capability Indices                          */
/*   PROCS: SPC                                                 */
/*    DATA:                                                     */
/*     REF: PROC SPC, Example 2                                 */
/*                                                              */
/****************************************************************/

data mycas.AllSpecs;
   length processname $16;
   input processname LSL Target USL;
   datalines;
Amount           11.95   12.00   12.05
Breakstrength    52.0    60.0      .
Delay              .      0      30
Diameter         34.98   35.00   35.01
KWatts         3400    3500    4000
Partgap         250     260     270
Time              7.85    8.0     8.15
Weight           23.0    24.0    25.0
;

proc spc data=mycas.AllProcesses;
   xrchart / exchart specs=mycas.AllSpecs;
run;

