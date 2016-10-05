%mend srs;

*invoke sas;

DATA Customers;
	INPUT 'c:\my_path\';
RUN;

%srs(j=10)



%MACRO select(customer=,sortvar=);

PROC SORT DATA = flowersales OUT=salesout;
	BY &sortvar;
	WHERE CustomerID= "&customer";
RUN;

PROC PRINT DATA = salesout;
	FORMAT SaleData WORDDATE18. SaleAmount DOLLAR7.;
	TITLE1 "Orders for Customer Number &customer";
	TITLE2 "Sorted by &sortvar";
RUN;

%MEND select;

DATA flowersales;
	INFILE 'c:\path';
	INPUT CustomerID $4. @6 SaleData MMDDYY10. @17 Variety $9. SaleQuantity SaleAmount;
RUN;

*invoke macro;

%select(customer = 356W,sortvar = SaleQuanitity)
%select(customer = 240W, sortvar = Variety)



/*macros with conditional logic*/

%MACRO dailyreports;
%IF &SYSDAY = Monday %THEN %DO;
	PROC PRINT DATA=flowesales;
		FORMAT SaleDate WORDDATE18. SaleAmount DOLLAR7.;
		TITLE 'Monday Report: CUrrent FLower Sales';
RUN;

%END;

%ELSE %IF &SYSDATE= Tuesday %THEN %DO;
	PROC MEANS DATA = flowersales MEAN MIN MAX;
		CLASS Variety
		VAR SaleQuantity;
		TITLE 'Tuesday Report: Summary of Flower Sales';
	RUN;
%END;
%MEND dailyreports;


DATA flowersales;
	INFILE 'c:\my_path\';
	INPUT CustomerId $4. @6 SaleDate MMDDYY10. @17 Variety $9. SaleQuantity SaleAmount;
RUN;

%dailyreports


/* Use SYMPUT to access data prior to execution   */

IF TotalSales > 1000000 THEN CALL SYMPUT("bestseller", BookTitle);
