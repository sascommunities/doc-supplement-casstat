/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPCEX4                                              */
/*   TITLE: Documentation Example 4 for PROC SPC                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Tests for Special Causes                            */
/*   PROCS: SPC                                                 */
/*    DATA:                                                     */
/*     REF: PROC SPC, Example 4                                 */
/*                                                              */
/****************************************************************/

data mylib.Random;
   length processname $16 subgroupname $16;
   do i = 1 to 100;
      processname  = 'Process'  || left( put( i, z3. ) );
      subgroupname = 'Subgroup' || left( put( i, z3. ) );
      do subgroup = 1 to 30;
         do j = 1 to 5;
            process = rannor(123);
            output;
         end;
      end;
   end;
   drop i j;
run;

proc spc data=mylib.Random;
   xchart / exchart
            tests    = 1 to 4
            outtable = mylib.RandomTests;
run;

