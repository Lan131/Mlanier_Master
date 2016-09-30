* create a user defined format


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
* print using DOLLAR8. format

PROC PRINT DATA= carsurvey;
	FORMAT Sex Gender. Age agegroup. Color @color. Income DOLLAR8.;
	TITLE 'Survey Results for car Data.";
RUN;
 

*Null data (produces no data set but can be used as a report of sorts)

DATA _NULL_;
	INFILE 'c/user_your_path_here'
	INPUT Name $ 1-11 Class @15 DateReturned MMDDYY10.
		CandyType $ Quantity
Profit=Quantity * 1.25;
FILE 'c:\MyRawDate\Student.txt' Print;
Title;

Put @5 'Candy sales report for ' Name ' rom classroom' Class// @5 'Congradulations! You sold ' Quantity 'boxes of candy'
/ @5 'and earned ' Profit DOLLAR6.2 ' for our field trip.';
PUT _PAGE_;
RUN;

* add summary breaks

DATA natparks
	INFILE 'c:\my_path_here\data.dat';
	INPUT Name $ 1-21 Type $ Region $ Museums Camping;
RUN;

*proc Report with breaks

PROC REPORT DATA=narparks NOWINDOWS;
	COLUMN Name Region Museums Camping ;
	DEFINE Region/ ORDER;
	BREAK AFTER Region / SUMMARIZE;
RBREAK AFTER / SUMMARIZE;
TITLE 'Detail Report with Summary Breaks';
RUN;

*add summary statistics to data


*stats in collum with 2 groups variables
PROC REPORT DATA = narparks NOWINDOWS;
	COLUMN Region Type N (museums Camping),MEAN;
	DEFINE Region / GROUP;
	DEFINE Type / GROUP;
	TITLE 'Statistics with a Group and Across Variable.';
RUN;

*stats in collum with 1 groups variable and 1 across variable
PROC REPORT DATA = narparks NOWINDOWS;
	COLUMN Region Type N (museums Camping),MEAN;
	DEFINE Region / GROUP;
	DEFINE Type / ACROSS;
	TITLE 'Statistics with a Group and Across Variable.';
RUN;


*create PDF

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
