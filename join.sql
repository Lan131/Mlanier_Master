
select  T1.*,T2.cust_id,T2.order_date as future_date,T2.units_purchased as future_purchase,DATEPART ( week , T2.order_date )  -DATEPART ( week , T1.order_date )  as diff
from Tab as T1 inner join Tab as T2 on T1.cust_id=T2.cust_id 
where 
DATEPART ( week , T2.order_date )  -DATEPART ( week , T1.order_date )  =1 and

 T2.units_purchased<4 


