*CSV import;

DATA Music;
infile 'path' DLM=',' DSD MISSOVER;
INPUT name $ 1-10 age 11-12;
run;

* create a user defined format;


DATA carsurvey;
	INPUT Age Sex Income Color $;
	DATALINES;
19 1 14000 Y
45 1 65000 G
72 2 35000 B
31 1 44000 Y
58 2 83000 W
;
end;

PROC FORMAT
	VALUE gender 1 = 'Male'
		     2 = 'Female';
	VALUE agegroup 13 -< 20 = 'Teen'
		       20 -< 65 = 'Adult'
		        65 - HIGH = 'Senior';
        VALUE $col 'W'='Moon White'
		   'B'='Sky Blue'
		   'Y'='Sunburst Yellow'
		   'G'= "Rain Cloud Gray';
* print using DOLLAR8. format;

PROC PRINT DATA= carsurvey;
	FORMAT Sex Gender. Age agegroup. Color @color. Income DOLLAR8.;
	TITLE 'Survey Results for car Data.";
RUN;
 

*Null data (produces no data set but can be used as a report of sorts);

DATA _NULL_;
	INFILE 'c/user_your_path_here';
	INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10.
		CandyType $ Quantity;
Profit=Quantity * 1.25;
FILE 'c:\MyRawDate\Student.txt' Print;
Title;

Put @5 'Candy sales report for ' Name ' rom classroom' Class// @5 'Congradulations! You sold ' Quantity 'boxes of candy'
/ @5 'and earned ' Profit DOLLAR6.2 ' for our field trip.';
PUT _PAGE_;
RUN;

* add summary breaks;

DATA natparks
	INFILE 'c:\my_path_here\data.dat';
	INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

*proc Report with breaks;

PROC REPORT DATA=narparks NOWINDOWS;
	COLUMN Name Region Museums Camping ;
	DEFINE Region/ ORDER;
	BREAK AFTER Region / SUMMARIZE;
RBREAK AFTER / SUMMARIZE;
TITLE 'Detail Report with Summary Breaks';
RUN;

*add summary statistics to data;


*stats in collum with 2 groups variables;
PROC REPORT DATA = narparks NOWINDOWS;
	COLUMN Region Type N (museums Camping),MEAN;
	DEFINE Region / GROUP;
	DEFINE Type / GROUP;
	TITLE 'Statistics with a Group and Across Variable.';
RUN;

*stats in collum with 1 groups variable and 1 across variable;
PROC REPORT DATA = narparks NOWINDOWS;
	COLUMN Region Type N (museums Camping),MEAN;
	DEFINE Region / GROUP;
	DEFINE Type / ACROSS;
	TITLE 'Statistics with a Group and Across Variable.';
RUN;


*create PDF;

ODS PDF FILE= 'c:\my_path_here\Marine.pdf' STARTPAGE=NO;
ODS NOPROCTITLE;

DATA marine;
	INFILE 'c:\MY_DATA\Lengths8.dat'
	INPUT Name $ Family $ Length @@;
RUN;

PROC MEANS DATA = marine MEAN MIN MAX;
CLASS Family;
TITLE 'Whales and Sharks';
RUN;

PROC PRINT DATA=marine;
RUN;
*close pdf
ODS PDF CLOSE;


*merge data;

DATA description;
	infile path TRUNCOVER;
	input CodeNum $ 1-4 Name $ 6-14 Desciption $ 15-60;
RUN;

DATA sales;
	infile path TRUNCOVER;
	input CodeNum $ 1-4 PiecesSold 6-7; 

PROC SORT Data=sales;
	By CodeNum;

RUN;


*Merge by code num;

DATA chocolates;
	MERGE sales descriptions;
	BY CodeNum;
Run;

PROC PRINT DATA=chocolates;

TITLE "Today's chocolate sales";

RUN;

* calculated fields;


libname sql 'SAS-library';

proc sql outobs=12;
   title 'U.S. Postal Codes';
   select 'Postal code for', Name, 'is', Code
      from sql.postalcodes;



libname sql 'SAS-library';

proc sql outobs=12;
   title 'Range of High and Low Temperatures in Celsius';
      select City, (AvgHigh - 32) * 5/9 as HighC format=5.1, 
                   (AvgLow - 32) * 5/9 as LowC format=5.1,
                   (calculated HighC - calculated LowC)
                    as Range format=4.1
   from sql.worldtemps;
RUN;


*calculated fields with running max;

DATA gamestats;
	INFILE 'c:\my_path\Games.dat'
	INPUT Month 1 Day 3-4 Team $ 6-25 Hits 27-28 Runs 30-31;
	RETAIN MaxRuns;
	MaxRun = MAX(MaxRuns, Runs);
	RunsToDate + Runs; *RunsToDate is modified by Runs, which is a variable. RunstoDate is an expression
Run;

PROC PRINT DATA= gamestats;
	TITLE "Season's record to date.";
RUN;

*add summary statistics to data;

DATA shoes;
	INFILE 'c:\my_path\shoe_data.dat';
	INPUT Style $ 1-15 ExerciseType $ Sales;
RUN;

PROC SORT DATA = shoes;
BY ExerciseType;
Run;

*Summarize by exercise type;

PROC MEANS NOPRINT DATA=shoes;
VAR=Sales;
By=ExerciseType;
OUTPUT OUT= summarydata SUN(Sales) = Total;

RUN;

PROC PRINT DATA= summarydata;
TITLE 'Summary data set';
RUN;

DATA shoesummary;
MERGE shoes summarydata;
BY ExerciseType;
Percent=Sales / Total *100;
RUN;

PROC PRINT DATA=shoesummary;
BY ExerciseType;
ID ExerciseType;
VAR STyle Sales Total Percent;
TITLE 'Sales Share by Type of Exercise';
RUN;


*freq proc;

DATA orders;
INFILE 'c:\my_path\coffee.dat';
INPUT Coffee $ Window $@@;

PROC FREQ DARA=orders;

TABLES Window Window*Coffee;

RUN;


*create data;

DATA Generate;

DO x=1 to 6;
y=x**2;
OUTPUT;
RUN;


*pivot data;
PROC TRANSPOSE DATA=baseball OUT=filipped;
By Team Player;
ID Type;
VAR Entry;

PROC PRINT DATA=flipped;
run;
