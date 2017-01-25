select Main.* from

(select T1.*,T2.order_date,T2.units_purchased,1
from Table_1 as T1 inner join Table_1 as T2 on T1.cust_id=T2.cust_id 
where DATEDIFF ( d , T1.order_date , T2.order_date ) >= 7 and DATEDIFF ( d , T1.date , T2.date ) <= 14 and T2.units_purchased<4) as MAIN left join Table_1 on Main.idx=T1.idx

