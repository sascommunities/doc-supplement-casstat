/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LMIXEDGS                                            */
/*   TITLE: Getting Started Example for PROC LMIXED             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Models, Analysis of Covariance                */
/*   PROCS: LMIXED                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC LMIXED, INTRODUCTORY EXAMPLE 1.              */
/*    MISC:                                                     */
/****************************************************************/

data mycas.SchoolSample;
   do SchoolID = 1 to 1000;
      do nID = 1 to 50;
         Neighborhood = (SchoolID-1)*15 + nId;
         bInt   = 15*ranuni(1);
         bTime  = 15*ranuni(1);
         bTime2 =   ranuni(1);
         do sID = 1 to 2;
            do Time = 1 to 4;
               Math = bInt + bTime*Time + bTime2*Time*Time + rannor(2);
               output;
               end;
            end;
         end;
      end;
run;

proc lmixed data=mycas.SchoolSample;
   class Neighborhood SchoolID;
   model Math = Time Time*Time / solution;
   random   int Time Time*Time / sub=Neighborhood(SchoolID) type=un;
run;

data one;
input p$ a$ b y count;
datalines;
P1 A1 1 8  2
P1 A1 2 10 1
P2 A2 1 7  3
P2 A1 2 8  2
P3 A1 1 12 2
P3 A2 2 9  1
P1 A2 1 7  3
P1 A2 2 8  2
P2 A2 1 7  3
P2 A2 2 9  2
;

data one;
input p$ a$ b y;
datalines;
P1 A1 1 8
P1 A1 1 8
P1 A1 2 10
P2 A2 1 7
P2 A2 1 7
P2 A2 1 7
P2 A1 2 8
P2 A1 2 8
P3 A1 1 12
P3 A1 1 12
P3 A2 2 9
P1 A2 1 7
P1 A2 1 7
P1 A2 1 7
P1 A2 2 8
P1 A2 2 8
P2 A2 1 7
P2 A2 1 7
P2 A2 1 7
P2 A2 2 9
P2 A2 2 9
;

