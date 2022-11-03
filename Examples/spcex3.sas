/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX3                                              */
/*   TITLE: Documentation Example 3 for PROC SPC                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Reading Preestablished Control Limits               */
/*   PROCS: SPC                                                 */
/*    DATA:                                                     */
/*     REF: PROC SPC, Example 3                                 */
/*                                                              */
/****************************************************************/

data mycas.StableProcesses;
   length processname $16 subgroupname $8;
   processname = 'Amount';
   subgroupname = 'Batch';
   do subgroup = 1 to 35;
      do i = 1 to 5;
         process = 12 + 0.045 * rannor(123);
         output;
      end;
   end;
   processname = 'Breakstrength';
   subgroupname = 'Sample';
   do subgroup = 1 to 28;
      do i = 1 to 5;
         process = 60 + 2 * rannor(234);
         output;
      end;
   end;
   processname = 'KWatts';
   subgroupname = 'Day';
   do subgroup = 1 to 55;
      do i = 1 to 20;
         process = 3500 + 210 * rannor(345);
         output;
      end;
   end;
   processname = 'Partgap';
   subgroupname = 'Sample';
   do subgroup = 1 to 36;
      do i = 1 to 5;
         process = 260 + 14 * rannor(456);
         output;
      end;
   end;
   processname = 'Time';
   subgroupname = 'Lot';
   do subgroup = 1 to 19;
      do i = 1 to 6;
         process = 8 + 0.055 * rannor(567);
         output;
      end;
   end;
   processname = 'Weight';
   subgroupname = 'Lot';
   do subgroup = 1 to 40;
      do i = 1 to 5;
         process = 25 + 2 * rannor(678);
         output;
      end;
   end;
   drop i;
run;

proc spc data=mycas.StableProcesses limits=mycas.AllLimits;
   xrchart;
run;

