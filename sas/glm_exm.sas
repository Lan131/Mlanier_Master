DATA MIXED;
INPUT #1 @1  (SUBJ)  (2.)
         @5  (GROUP) (1.)
         @10 (PRE)   (2.)
         @15 (POST)  (2.)
         @20 (FOLUP) (2.);
CARDS;
01  1    08   10   10
02  1    10   13   12
03  1    07   10   12
04  1    06   09   10
05  1    07   08   09
06  1    11   15   14
07  1    08   10   09
08  1    05   08   08
09  1    12   11   12
10  1    09   12   12
11  2    10   14   13
12  2    07   12   11
13  2    08   08   09
14  2    13   14   14
15  2    11   11   12
16  2    07   08   07
17  2    09   08   10
18  2    08   13   14
19  2    10   12   12
20  2    06   09   10
;


/* The following program is found on p. 350 of      */
/* A Step-by-Step Approach to Using the SAS System  */
/* for Univariate and Multivariate Statistics.      */


PROC GLM  DATA=MIXED;
   CLASS GROUP;
   MODEL PRE POST FOLUP = GROUP / NOUNI;
   REPEATED TIME 3 CONTRAST (1) / SUMMARY;
   RUN;


/* The following program is found on p. 364 of      */
/* A Step-by-Step Approach to Using the SAS System  */
/* for Univariate and Multivariate Statistics.      */


DATA CONTROL;
   SET MIXED;
   IF GROUP=1 THEN OUTPUT;
   RUN;

DATA EXP;
   SET MIXED;
   IF GROUP=2 THEN OUTPUT;
   RUN;

PROC GLM  DATA=CONTROL;
   MODEL PRE POST FOLUP =  / NOUNI;
   REPEATED TIME 3 CONTRAST (1) / SUMMARY;
   RUN;

PROC GLM  DATA=EXP;
   MODEL PRE POST FOLUP =  / NOUNI;
   REPEATED TIME 3 CONTRAST (1) / SUMMARY;
   RUN;


/* The following program is found on p. 369 of      */
/* A Step-by-Step Approach to Using the SAS System  */
/* for Univariate and Multivariate Statistics.      */

PROC GLM DATA=MIXED;
   CLASS GROUP;
   MODEL PRE = GROUP ;
   RUN;

PROC GLM DATA=MIXED;
   CLASS GROUP;
   MODEL POST = GROUP ;
   RUN;

PROC GLM DATA=MIXED;
   CLASS GROUP;
   MODEL FOLUP = GROUP ;
   RUN;


/* The following program is found on p. 375 of      */
/* A Step-by-Step Approach to Using the SAS System  */
/* for Univariate and Multivariate Statistics.      */


DATA MIXED1;
   SET MIXED;
   TIME='PRE';
   INVEST=PRE;
   OUTPUT;
   TIME='POST';
   INVEST=POST;
   OUTPUT;
   TIME='FOLUP';
   INVEST=FOLUP;
   OUTPUT;
   RUN;


/* The following program is found on p. 376 of      */
/* A Step-by-Step Approach to Using the SAS System  */
/* for Univariate and Multivariate Statistics.      */

PROC GLM DATA=MIXED1;
   CLASSES SUBJ GROUP TIME;
   MODEL INVEST = GROUP SUBJ(GROUP) TIME GROUP*TIME
   TIME*SUBJ(GROUP);
   TEST H=GROUP    E=SUBJ(GROUP)
   TEST H=TIME GROUP*TIME    E=TIME*SUBJ(GROUP);
   MEANS TIME / TUKEY;
   RUN;
