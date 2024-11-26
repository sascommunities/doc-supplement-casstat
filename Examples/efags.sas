/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: efags                                               */
/*   TITLE: Getting Started Example for PROC EFA                */
/*    DESC: Factor Analysis                                     */
/* PRODUCT: SAS Visual Statistics                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, factor extraction, factor rotation */
/*   PROCS: EFA                                                 */
/*    DATA:                                                     */
/*                                                              */
/*    MISC:                                                     */
/****************************************************************/

options validvarname=any;
data mylib.jobratings;
   input ('Communication Skills'n
      'Problem Solving'n
      'Learning Ability'n
      'Judgment under Pressure'n
      'Observational Skills'n
      'Willingness to Confront Problems'n
      'Interest in People'n
      'Interpersonal Sensitivity'n
      'Desire for Self-Improvement'n
      'Appearance'n
      'Dependability'n
      'Physical Ability'n
      'Integrity'n) (1.);
   datalines;
2683885387986
7475887685766
5675786377587
6786977798899
9999779887888
8989789988879
8999988989979
8779479846888
3565233514311
8988887957686
7655789944639
9788999889898
7676667759888
7766767677967
6383993258885
2573881128491
8887996679798
8797987795967
8798997587879
9988998889888
7887676568767
8888988889989
8888998887898
6764657738477
7877878879999
7688886676866
6767866574677
3342447666485
6565676578576
5456667656586
5665556665677
8888998886888
8989999989879
9888999989989
5755477646887
5368777779788
6866671647576
7877888979899
6736476756584
7767886588676
6869895566999
5554686666388
6888899999898
9778788879899
7667789979999
4475468787778
7787667879888
7666877879979
5765363436154
7677774565365
7676666565667
8888888887878
8897788886977
5889488874788
5867456547367
7677776777777
7778887878979
9898998799986
6672991147471
9888997699998
8878685666774
7786888789788
9999998699999
4668858761688
6675577848677
8777778888979
6566665654597
7357448888768
7475555658659
7667777878979
8787874677766
8677695587487
7788876777867
6577878777899
5878688778798
6578776667677
8677787546877
6778887775777
7777896785586
6788787676777
2478658553586
4653234354253
3556676667678
1123121421121
7688658853688
5778478868858
5666776646566
6678777877889
7768799887799
7666888854667
6647798758999
8678897688459
7786876578547
9998888898788
6594893388645
9999987798889
9663673687658
9867688779896
8787887789897
8889788888878
9999789979979
9989989989989
7665639956748
;

proc efa data=mylib.jobratings rotate=varimax;
   nfactors type=parallel alpha=0.05 seed=1031 nsimulations=20000;
   nfactors type=parallel alpha=0.05 seed=1128 nsimulations=20000;
   nfactors type=parallel alpha=0.10 seed=1031 nsimulations=20000;
   nfactors type=parallel alpha=0.10 seed=1128 nsimulations=20000;
   nfactors type=eigenvalue threshold=0.5  status=inactive;
   nfactors type=eigenvalue threshold=1.0  status=inactive;
   nfactors type=proportion threshold=0.9  status=inactive;
   nfactors type=proportion threshold=0.95 status=inactive;
   nfactors type=map2 status=inactive;
   nfactors type=map4 status=inactive;
run;

