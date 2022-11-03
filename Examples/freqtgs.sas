/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FREQTGS                                             */
/*   TITLE: Getting Started Example for PROC FREQTAB            */
/* PRODUCT: AASTATISTICS                                        */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis, frequency tables,        */
/*    KEYS: crosstabulation tables, multiway tables,            */
/*    KEYS: chi-square statistics, measures of association,     */
/*    KEYS: Cochran-Mantel-Haenszel statistics, ODS graphics    */
/*   PROCS: FREQTAB                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC FREQTAB, GETTING STARTED EXAMPLE               */
/*    MISC:                                                     */
/****************************************************************/

proc format casfmtlib='myfmtlib';
   value ResponseCode
      1 = 'Very Satisfied'
      2 = 'Satisfied'
      3 = 'Neutral'
      4 = 'Unsatisfied'
      5 = 'Very Unsatisfied';
run;

proc format casfmtlib='myfmtlib';
   value SchoolCode
      1 = 'Middle School (Private)'
      2 = 'Middle School (Public)'
      3 = 'High School (Private)'
      4 = 'High School (Public)';
run;

data example;
   ID = 1;
   format Response ResponseCode.;
   format SchoolType SchoolCode.;
   call streaminit(11111);
   seed = 12345;

   State = 'GA';
   do ID = 1 to 8231;
      call rantbl ( seed, .12, .28, .25, .35, SchoolType );
      if ( SchoolType = 1 ) then
         call rantbl( seed, .16, .22, .31, .22, .09, Response );
      else if ( SchoolType = 2 ) then
         call rantbl( seed, .13, .19, .28, .28, .12, Response );
      else if ( SchoolType = 3 ) then
         call rantbl( seed, .18, .26, .31, .18, .07, Response );
      else if ( SchoolType = 4 ) then
         call rantbl( seed, .14, .22, .29, .25, .10, Response );
      rannum = rand('uniform');
      output;
   end;

   State = 'NC';
   do ID = 8232 to 19787;
      call rantbl ( seed, .12, .28, .25, .35, SchoolType );
      if ( SchoolType = 1 ) then
         call rantbl( seed, .16, .22, .31, .22, .09, Response );
      else if ( SchoolType = 2 ) then
         call rantbl( seed, .13, .19, .28, .28, .12, Response );
      else if ( SchoolType = 3 ) then
         call rantbl( seed, .19, .27, .30, .17, .07, Response );
      else if ( SchoolType = 4 ) then
         call rantbl( seed, .14, .22, .29, .25, .10, Response );
      rannum = rand('uniform');
      output;
   end;

   State = 'SC';
   do ID = 19788 to 23325;
      call rantbl ( seed, .10, .30, .22, .38, SchoolType );
      if ( SchoolType = 1 ) then
         call rantbl( seed, .15, .22, .31, .22, .10, Response );
      else if ( SchoolType = 2 ) then
         call rantbl( seed, .14, .22, .29, .25, .10, Response );
      else if ( SchoolType = 3 ) then
         call rantbl( seed, .19, .27, .30, .18, .06, Response );
      else if ( SchoolType = 4 ) then
         call rantbl( seed, .14, .22, .29, .25, .10, Response );
      rannum = rand('uniform');
      output;
   end;

   State = 'TN';
   do ID = 23326 to 32459;
      call rantbl ( seed, .12, .28, .25, .35, SchoolType );
      if ( SchoolType = 1 ) then
         call rantbl( seed, .15, .22, .31, .22, .11, Response );
      else if ( SchoolType = 2 ) then
         call rantbl( seed, .15, .21, .29, .23, .12, Response );
      else if ( SchoolType = 3 ) then
         call rantbl( seed, .18, .28, .30, .17, .07, Response );
      else if ( SchoolType = 4 ) then
         call rantbl( seed, .14, .22, .29, .25, .10, Response );
      rannum = rand('uniform');
      output;
   end;

run;

proc sort data=example nothreads;
   by rannum;
run;

data mycas.School_Survey;
   set example;
   drop rannum seed;
run;

proc freqtab data=mycas.School_Survey;
   tables SchoolType * Response /
      crosslist chisq measures(cl);
run;

ods graphics on;
proc freqtab data=mycas.School_Survey;
   tables Response * SchoolType /
      plots=(freqplot(twoway=cluster orient=h scale=grouppercent)
             mosaicplot(colorstat=stdres));
run;
ods graphics off;

proc freqtab data=mycas.School_Survey;
   tables State * SchoolType * Response / cmh;
run;

