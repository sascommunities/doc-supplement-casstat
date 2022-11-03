/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NMFEX1                                              */
/*   TITLE: Documentation Example 1 for PROC NMF                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multivariate Analysis                               */
/*   PROCS: NMF                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC NMF, Example 1                                 */
/*    MISC:                                                     */
/****************************************************************/

data mycas.ex1Data;
   infile datalines delimiter='|' missover;
   length text $150;
   input text$ did;
   datalines;
      Reduces the cost of maintenance. Improves revenue forecast.        | 1
      Analytics holds the key to unlocking big data.                     | 2
      The cost of updates between different environments is eliminated.  | 3
      Ensures easy deployment in the cloud or on-site.                   | 4
      Organizations are turning to SAS for business analytics.           | 5
      This removes concerns about maintenance and hidden costs.          | 6
      Service-oriented and cloud-ready for many cloud infrastructures.   | 7
      Easily apply machine learning and data mining techniques to data.  | 8
      SAS Viya will address data analysis, modeling and learning.        | 9
      Helps customers reduce cost and make better decisions faster.      | 10
      Simple, powerful architecture ensures easy deployment in the cloud.| 11
      SAS is helping industries glean insights from data.                | 12
      Solve complex business problems faster than ever.                  | 13
      Shatter the barriers associated with data volume with SAS Viya.    | 14
      Casual business users, data scientists and application developers. | 15
      Serves as the basis for innovation causing revenue growth.         | 16
run;

proc textmine data=mycas.ex1Data;
   doc_id     did;
   variables  text;
   parse      stop      = mycas.en_stoplist
              outterms  = mycas.terms
              outparent = mycas.termdoc
              reducef   = 1;
run;

data terms; set mycas.terms; keep Term Key;
   rename Key=_termnum_;
run;
proc sort data=terms; by _termnum_; run;

data termdoc; set mycas.termdoc; run;
proc sort data=termdoc; by _termnum_ _document_; run;

data termdoc1; merge terms termdoc; by _termnum_;
   if missing(_count_) then delete;
run;

proc sql noprint;
   select max(_document_) into :max_docid from termdoc1;
run;
%let maxid = &max_docid;

data mycas.termdoc2;
   length id 8;
   array docs{&maxid} doc1 - doc&maxid;
   retain doc1 - doc&maxid;
   set termdoc1;
   by _termnum_;
   id = _termnum_;
   if First._termnum_ then do;
      do i= 1 to &maxid;
         docs{i} = 0;
      end;
   end;
   docs{_document_} = _count_;
   if Last._termnum_;
   drop i _termnum_ _document_ _count_;
run;

proc nmf data=mycas.termdoc2 seed=789 rank=5 outh=mycas.H;
   var doc1-doc&maxid;
   output out=mycas.W comp=Topic copyvar=Term;
run;

proc cas;
   action table.fetch /
      table='W'
      fetchVars={'Term', 'Topic3'}
      sortby={{name='Topic3' order='descending'}}
      to=10;
run;
quit;

proc cas;
   topic=${Topic1-Topic5};
   cols='_Index_' + topic;
   coltypes=${integer, varchar, varchar, varchar, varchar, varchar};
   Topics=newtable('Topics', cols, coltypes);

   t={};
   do i=1 to 5;
      table.fetch result=r /
         table='W'
    	    fetchVars={'Term'}
         sortby={{name=topic[i] order='descending'}}
         to=10;
      t[i]=r.Fetch[, 'Term'];
   end;

   row={};
   do j=1 to 10;
      row[1]=j;
      do i=1 to 5; row[i+1]=t[i][j]; end;
      addrow(Topics, row);
   end;

   print Topics;
run;
quit;

