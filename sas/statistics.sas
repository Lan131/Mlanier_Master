/* Statistical procedures */

/*univariate procedures*/


DATA class;
INFILE 'c:\my_path';
INPUT Score @@;
RUN;


*all statistics at once;

PROC UNIVARIATE DATA = class;
	VAR Score;
	TITLE;

RUN;


/* add graphs */


PROC UNIVARIATE DATA = class;
	VAR Score;
	HISTOGRAM Score / NORMAL;  *could be QQPLOT. CDFPLOT; *could be EXPONENTIAL, PARETO, etc;
	PROBPLOT Score;
	TITLE;

RUN;


*specific statistics;

PROC MEANS DATA= class;
	VAR N ,MIN, MODE, MAX, P50, RANGE, VAR, CLM ALPHA=.1;
	TITLE 'A bunch of statistics';
RUN;

 *T Test;

PROC DATA Swim;
INPUT Swimmer $ SemiTime FinalTime;

Datalines;

RK 24.05 24.07
AH 24.28 25.36
MV 25.95 27.36
BS 48.5  48
FH 14.15 14.35
TA 23.25 22.5
JH 26.84 26.99
AV 27.32 27.01
;

RUN;

PROC TTest Data=Swim;
TITLE '50m freestype times';
PAIRED SemiTime * FinalTime;
RUN;



*Catagorical Data and PROC FREQ;

DATA bus;
INFILE 'c:\my_path';
INPUT BusType $ OnTimeOrLate $ @@;

/*E or R for early regular, L or O for Late or on time*/
/*    E O E L E L R O E .... */

Run;


PROC FREQ DATA= bus;
	TABLES BusType * OnTimeOrLate / CHISQ;
TITLE;
RUN;

*graphs;

PROC FORMAT;
	VALUE $type 'R'='Regular'
		     'E'='Express';
		$late 'O'='On Time'
		       'L'='Late';
RUN;

PROC FREQ Data= bus;
	TABLES BusType * OnTimeOrLate / PLOTS=FREQPLOT(TWOWAY=GROUPHORIZONTAL);
	FORMAT BusType $Type. OnTimeOrLate $Late;
RUN;

*correlations;

PROC CORR Data=class;
	Car Television Exercise;
	WITH Score;
	TITLE 'Correlations for Test Scores';
RUN;

/*correlation graphs;

PROC CORR DATA=class PLOTS= (SCATTER MATRIX);
	WITH Score;
	TITLE 'Correlations for the Test Scores';
RUN;





*Regression;

Data HITS;
INFILE 'c:\my_path\';
INPUT Height Distance @@;
RUN;

PROC REG DATA=hits;
	MODEL Distance=Height;
	TITLE 'Regression Distance onto Height';
RUN;

/*with plots*/

PROC REG DATA=hits PLOTS(ONLY)=(DIAGNOSTICS FITPLOT);
	MODEL Distance = Height;
	TITLE 'Regression Results';
RUN;


/*ANOVA*/

DATA heights;
	INFILE 'c:\my_path\';
	INPUT Reigion $ Height @@;
/* West 65 West 58 East 21...  */
RUN;

PROC ANOVA DATA=heights;
	CLass Region'
	MODEL Height=Region;
	Means Region / SCHEFFE BON;
	TITLE "Girls' Heights for different regions.";
RUN;







PROC ANOVA DATA=heights;

