data one;
   do x=0 to 2 by 0.01;
      y=rannor(1);
      output;
   end;
run;

ods listing close;
proc glmselect data=one outdesign(addinputvars prefix=linear)=two;
   effect spl=spline(x/knotmethod=list(1) details basis=tpf degree=1);
   model y=spl/selection=none;
run;

proc glmselect data=two outdesign(addinputvars prefix=cubic names)=three;
   effect spl=spline(x/knotmethod=list(1) details basis=tpf);
   model y=spl/selection=none;
run;

proc template;
   define statgraph tpf;
      beginGraph / designheight=240;
         layout lattice/columns=2
                        rowdatarange=unionall
                        columnGutter=10;
            rowaxes;
               rowaxis / display=(line ticks tickvalues)
                         offsetmin=0.05 offsetmax=0.05;
            endrowaxes;
            layout overlay / yaxisopts=(display=none);
               entry "Linear" / location = outside textattrs=GraphTitleText;
               seriesplot x=x y=linear4/
                  lineattrs = GraphData1(color=blue);
               referenceline x=1;
            endlayout;
            layout overlay / yaxisopts=(display=none);
               entry "Cubic" / location = outside textattrs=GraphTitleText;
               seriesplot x=x y=cubic6/
                  lineattrs = GraphData1(color=blue);
               referenceline x=1;
            endlayout;
         endlayout;
      endGraph;
   end;
run;

ods listing;
proc sgrender data=three template=tpf;
run;

data one;
   do x=0 to 1 by 0.01;
      y=rannor(1);
      output;
   end;
run;

ods listing close;
proc glmselect data=one outdesign(addinputvars)=linear;
   effect linear=spline(x/knotmethod=equal(4) databoundary details degree=1);
   model y=linear/selection=none;
run;

proc glmselect data=one outdesign(addinputvars)=cubic;
   effect cubic=spline(x/knotmethod=equal(4) details databoundary degree=3);
   model y=cubic/selection=none;
run;

proc glmselect data=one outdesign(addinputvars)=cubicequal;
   effect cubic=spline(x/knotmethod=equal(4) details degree=3);
   model y=cubic/selection=none;
run;


%macro fns(prefix,n);
   %do i=1 %to &n;
      seriesplot x=x y=&prefix&i / lineattrs = GRAPHDATA&i(pattern=solid);
   %end;
%mend;


proc template;
   define statgraph bsplineLinear;
      beginGraph / designheight=240;
         layout overlay/yaxisopts=(display=(line ticks tickvalues)
                                   offsetmin=0.05 offsetmax=0.05);
            %fns(linear_,6);
         endlayout;
      endGraph;
   end;

   define statgraph bsplineCubic;
      beginGraph / designheight=320;
         layout overlay/yaxisopts=(display=(line ticks tickvalues)
                                   offsetmin=0.05 offsetmax=0.05);
            %fns(cubic_,8);
         endlayout;
      endGraph;
   end;
run;

ods listing;
proc sgrender data=linear template=bsplineLinear;
run;
proc sgrender data=cubic template=bsplineCubic;
run;
proc sgrender data=cubicequal template=bsplineCubic;
run;

ods listing close;
proc glmselect data=one outdesign(addinputvars)=naturalCubic;
   effect natCubic=spline(x/knotmethod=equal(4) details naturalcubic);
   model y=natCubic/selection=none noint;
run;

proc template;
   define statgraph naturalBasis;
      beginGraph / designheight=240;
         layout overlay/yaxisopts=(display=(line ticks tickvalues)
                                   offsetmin=0.1 offsetmax=0.1);
            %fns(natCubic_,4);
            referenceline x=0.2;
            referenceline x=0.8;
         endlayout;
      endGraph;
   end;
run;

ods listing;
proc sgrender data=naturalCubic template=naturalBasis;
run;

   data mycas.exampleData;
      drop i j;
      array x{20} x1-x20;
      array c{5}  c1-c5;

      call streaminit(1);

    do i=1 to 15000;
       do j=1 to dim(x);
          x{j} = rand('NORMAL');
       end;

       do j=1 to dim(c);
          c{j} = 1+ int(rand('UNIFORM')*3);
       end;

       y = 1 + x1 + 2*x5 - 1.3*x10 + x20 + 5*(c1=1)+3*(c1=3) - 4*c4 + 25*rand('NORMAL');

            if mod(i,3)=1 then Role = 'TRAIN';
       else if mod(i,3)=2 then Role = 'VAL';
       else                    Role = 'TEST';

       output;
    end;
 run;


ods graphics on;

proc regselect data=mycas.exampleData;
   partition rolevar=Role(train='TRAIN' validate='VAL' test='TEST');
   class c: ;
   model y = x: c:  ;
   selection method=forward(stop=AICC CHOOSE=validate) plots=all;
run;



proc regselect data=mycas.exampleData;
   partition rolevar=Role(train='TRAIN' validate='VAL' test='TEST');
   class c: ;
   model y = x: c: ;
   selection method=forward(stop=none choose=validate)
             plots(maxparmlabel=1 stepaxis=number)=(coefficients criteria(unpack));
run;


proc regselect data=mycas.exampleData;
   partition rolevar=Role(train='TRAIN' validate='VAL' test='TEST');
   class c: ;
   model y = x: c: ;
   selection method=forward(stop=none choose=validate)
             plots(startstep=3 endstep=8)=criteria;
run;

ods graphics off;

