
/* SELECT k.A-j.avg from
(SELECT avg(A) as avg from data1) as j cross join (SELECT A from data1) as k */

libmane clinic 'your-path here';

*column total at bottom;
PROC PRINT DATA=clinic.admit;
  SUM fee;
RUN;

*rename column in print;

PROC PRINT DATA=clinic.admit;
  var age height weight fee;
  label fee = 'Admission Fee';
  
RUN;


*subtotals;

PROC PRINT DATA=work.activity;
  VAR age height weight fee;
  WHERE age > 30;
  by actlevel;
  * id actlevel;
RUN;





