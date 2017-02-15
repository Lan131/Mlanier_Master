set transaction isolation level serializable;
@id=123
being transaction
if exists (select id from table where id=@id)
update table set amount=(select amount from table_2 order by amount desc limit 1) where id=@id;
else
insert into table (select * from table_2 where id=@id);
commit;
go;



