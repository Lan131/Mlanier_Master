select T1.cust_id,T1.date,T1.Items
from Table_1 as T1 inner join Table_1 as T2 on T1.cust_id=T2.cust_id 
where DATEDIFF ( d , T1.date , T2.date ) >= 7 and DATEDIFF ( d , T1.date , T2.date ) <= 14 and T2.items<4
