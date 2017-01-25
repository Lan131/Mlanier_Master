select distinct T1.*,T2.cust_id,T2.order_date as future_date,T2.units_purchased as future_purchase,1
from Tab as T1 inner join Tab as T2 on T1.cust_id=T2.cust_id 
where 

T2.order_date >= DATEADD(dd, ((DATEDIFF(dd, '17530101', T1.order_date) / 7) * 7) + 7, '17530101') AND
    T2.order_date <= DATEADD(dd, ((DATEDIFF(dd, '17530101', T1.order_date) / 7) * 7) + 13, '17530101') AND



 T2.units_purchased<4 


