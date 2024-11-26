/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NMFEX2                                              */
/*   TITLE: Documentation Example 2 for PROC NMF                */
/* PRODUCT: AACAS                                               */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multivariate Analysis                               */
/*   PROCS: NMF                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC NMF, Example 2                                 */
/*    MISC:                                                     */
/****************************************************************/

proc python;
   submit;

import pandas as pd
import numpy as np

# load data from the file
colname = ['userID', 'movieID', 'rating']
colpick = [0, 1, 2]
df = pd.read_csv('u.data', delimiter='\t', usecols=colpick, names=colname)

# store data in dense matrix format
nrow = max(df.loc[:, 'userID'])
ncol = max(df.loc[:, 'movieID']) + 1
mat = np.full((nrow, ncol), np.nan)

for i in range(0, nrow):
   mat[i, 0] = i+1

for idx, rowSeries in df.iterrows():
   val = rowSeries.values
   mat[val[0]-1, val[1]] = val[2]

# transfer data to a SAS data table
cols = ['UserID'] + ['M%d' %i for i in range(1, ncol)]
matdf = pd.DataFrame(mat, columns=cols)

SAS.df2sd(matdf, 'mylib.ratings')

   endsubmit;
run;

proc nmf data=mylib.ratings rank=19 seed=6789
         method=apg(maxiter=600) reg=L2(alpha=5 beta=5);
   var m:;
   impute out=mylib.outX imputedRowsOnly predOnly copyvar=UserID;
run;

proc python;
   submit;

import pandas as pd
import numpy as np
import csv

# fetch the first 10 observations
df = SAS.sd2df('mylib.outX(obs=10)')

# load information about the movies
movieDict = {}
csvFile = csv.reader(open('u.item', encoding='latin-1'), delimiter='|')
for row in csvFile:
   key = 'M' + row[0]
   movieDict[key] = row[1]

# top 10 recommended movies for a single user
row = 8
uid = df.iloc[row, 0]
rating = df.iloc[row, 1:].sort_values(ascending=False, inplace=False)
colUid = [uid]*10
colRank = np.arange(1, 11).tolist()
colMid = rating.index.tolist()[0:10]
colRate = rating.values.tolist()[0:10]
colTitle = []
for i in range(0, 10):
   colTitle.append(movieDict[rating.index[i]])

cols = ['UserID', 'Rank', 'MovieID', 'Title', 'PredictedRating']
topRating = pd.DataFrame(list(zip(colUid, colRank, colMid, colTitle, colRate)),
                         columns=cols)
SAS.df2sd(topRating, 'topRating')

# top 5 recommended movies for each of the 10 users
movies = []
for idx, rowSeries in df.iterrows():
   uid = rowSeries.pop('UserID')
   rowSeries.sort_values(ascending=False, inplace=True)
   row = [uid]
   for i in range(0, 5):
      row.append(movieDict[rowSeries.index[i]])
   movies.append(row)

cols = ['UserID', '_1_', '_2_', '_3_', '_4_', '_5_']
topRecom = pd.DataFrame(movies, columns=cols)
SAS.df2sd(topRecom, 'topRecom')

   endsubmit;
run;

proc print data=topRating;
run;

proc print data=topRecom;
run;

