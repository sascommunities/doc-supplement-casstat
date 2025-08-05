

data mylib.dataForTrain / single=yes;
   drop i;
   array x{5};
   array z{2};
   call streaminit(6520);
   pi=constant("pi");

   do i=1 to 5000;
     x1=rand("Normal");
     x2=rand("Uniform");
     z1=rand("Bernoulli",0.7);
     x3=rand("Normal",x1*z1,0.6*z1);
     z2=rand("Bernoulli",logistic(z1*x3));
     x4=rand("Normal",0,0.8*z2);
     if (x4 - z1) > 0 then x5 = x4 - z1;
     else x5 = (x4 - z1)**2;

     y=2+x1+x1*z1+sin(pi/2*x2)+x3**2+z2+x4**3+x5+rand("Normal");
   output;

   end;
run;

proc superlearner data=mylib.dataForTrain seed=2324;
   target y / level=interval;
   input z1 z2 / level=nominal;
   input x1-x5 / level=interval;
   baselearner 'lm' regselect;
   baselearner 'lasso_2way' regselect(selection=elasticnet(lambda=5 mixing=1))
     class=(z1 z2) effect=(z1|z2|x1|x2|x3|x4|x5 @2);
   baselearner 'gam' gammod class=(z1 z2) param(z1 z2 x1 x2)
     spline(x3) spline(x4) spline(x5);
   baselearner 'bart' bart(nTree=10 nMC=100);
   baselearner 'forest' forest;
   baselearner 'svm' svmachine;
   baselearner 'factmac' factmac(nfactors=4 learnstep=0.15);
   store out=mylib.slmodel;
run;


data mylib.dataForScore / single=yes;
   drop j;
   array x{5};
   array z{2};
   call streaminit(2456);
   pi=constant("pi");

   do i=1 to 1000;
     x1=rand("Normal");
     x2=rand("Uniform");
     z1=rand("Bernoulli",0.7);
     x3=rand("Normal",x1*z1,0.6*z1);
     z2=rand("Bernoulli",logistic(z1*x3));
     x4=rand("Normal",0,0.8*z2);
     if (x4 - z1) > 0 then x5 = x4 - z1;
     else x5 = (x4 - z1)**2;

     y=2+x1+x1*z1+sin(pi/2*x2)+x3**2+z2+x4**3+x5+rand("Normal");
   output;

   end;
run;

proc superlearner data=mylib.dataForScore restore=mylib.slmodel;
   output out=mylib.scoredData1 learnerpred;
run;

proc print data=mylib.scoredData1(obs=10);
run;

proc superlearner data=mylib.dataForScore restore=mylib.slmodel;
   margin "Scenario1" z1=0 x1=0.25;
   margin "Scenario2" x1=0.25;
   margin "Scenario3" x1=0.5;
   margin "Scenario4" x1=0.75;
   output out=mylib.scoredData2 marginpred;
run;

proc print data=mylib.scoredData2(obs=10);
run;

