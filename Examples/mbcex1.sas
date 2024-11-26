/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: mbcex1                                              */
/*   TITLE: Example for PROC MBC                                */
/*    DESC: Market segmentation                                 */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Three-component Gaussian mixture, with noise        */
/*          four-dimensional continuous response                */
/*   PROCS: MBC                                                 */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data mylib.marketdata;
  label moninc  = 'Monthly Income'
        mondebt = 'Monthly Debt'
        tenancy = 'Months at Current Residence'
        ageyrs  = 'Age';

  call streaminit(869884);

  * -- Segment 1 : Young Spenders ------------ ;
  do j = 1 to 1000;
    moninc  = 12 + sqrt(2)    * rand('normal');
    mondebt =  6 + sqrt(1)    * rand('normal');
    tenancy = 18 + sqrt(2)    * rand('normal');
    ageyrs =  30 + sqrt(8)    * rand('normal');
    output;
  end;
  * -- Segment 2 : Middle-Aged Savers -------- ;
  do j = 1 to 3000;
    moninc  = 10 + sqrt(2.5)  * rand('normal');
    mondebt =  2 + sqrt(0.25) * rand('normal');
    tenancy = 24 + sqrt(3)    * rand('normal');
    ageyrs =  40 + sqrt(8)    * rand('normal');
    output;
  end;
  * -- Segment 3 : Comfortably Established --- ;
  do j = 1 to 6000;
    moninc  = 15 + sqrt(2)    * rand('normal');
    mondebt =  3 + sqrt(0.5)  * rand('normal');
    tenancy = 32 + sqrt(4)    * rand('normal');
    ageyrs =  50 + sqrt(5)    * rand('normal');
    output;
  end;
  * -- Segment 4: Defying Classification ----- ;
  do j = 1 to 300;
    moninc  = rand('uniform') * 15 +  5;
    mondebt = rand('uniform') *  9 +  0;
    tenancy = rand('uniform') * 30 + 10;
    ageyrs  = rand('uniform') * 40 + 20;
    output;
  end;
  drop j;
;

proc mbc data=mylib.marketdata nclusters=(2 3 4 5) noise=YES seed=1389035719;
  var moninc mondebt tenancy ageyrs;
  store mylib.mktgroups;
  output out=mylib.marketscores maxpost copyvars=(moninc mondebt tenancy ageyrs);
run;

data mylib.newcusts;
input moninc    mondebt    tenancy     ageyrs;
datalines;
 7      5      20      35
12      6      20      30
18      4      31      52
10      4      25      37
;

proc cas;
  action mbc.mbcScore /
    table={name='newcusts'}
    restore={name='mktgroups'}
    casOut={name='newScores', replace=true}
    copyvars={'moninc' , 'mondebt' , 'tenancy' , 'ageyrs'}
    maxpost='group'
    nextclus='cluswt';
  run;
quit;

proc print data=mylib.newScores noobs;
run;

