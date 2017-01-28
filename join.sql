
USE [my_db]
GO

select distinct L.*,ISNULL(R.response,0) as response from

(select Tab.*,A.ct from Tab left join
(select  cust_id, count(*) as ct from Tab where order_date< '9/17/2015' group by cust_id  ) as A on Tab.cust_id=A.cust_id

 where order_date> '9/17/2015') as L left join 

 (select 1 as response,T1.idx
from Tab as T1 inner join Tab as T2 on T1.cust_id=T2.cust_id 
where 
DATEPART ( week , T2.order_date )  -DATEPART ( week , T1.order_date )  =1 and
DATEPART ( yy , T2.order_date ) - DATEPART ( yy , T1.order_date )=0 and
T2.units_purchased<4) as R on L.idx=R.idx where L.order_date<'3/20/2016' order by L.idx
