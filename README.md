start at 07/08/2562 \
backend 

BLOG to create postgres REST API \
https://blog.logrocket.com/setting-up-a-restful-api-with-node-js-and-postgresql-d96d6fc892d8/


CREATE TABLE option (
   id serial primary key,
   name text,
   price integer ARRAY[4],
   tail text[][]
);

INSERT INTO option(name,price,tail) 
VALUES ('Manisha', 
'{20000, 14600, 23500, 13250}', 
'{{“FD”, “MF”}, {“FD”, “Property”}}');

 id |  name   |           price           |              tail               
----+---------+---------------------------+---------------------------------
  1 | Manisha | {20000,14600,23500,13250} | {{“FD”,“MF”},{“FD”,“Property”}}
(1 row)

api=# select price[1],price[3] from option where id=1; 
 price | price 
-------+-------
 20000 | 23500
(1 row)

api=# select tail[1][2],tail[2][2] from option ;
 tail |    tail    
------+------------
 “MF” | “Property”
(1 row)

INSERT INTO option(name,price,tail) 
VALUES ('Apisit Prompha', 
'{1, 2, 3, 4}', 
'{{“A”, “B”}, {“C”, “D”}}');



me=# select optionvaluename[1],optionvalue[1] from optionvalue where optionvalueid = 2;
 optionvaluename | optionvalue 
-----------------+-------------
 สี               | ขาว
(1 row)

-- insert and return value

`with ins1 as (
            insert into product (createdate,photo,proname,prodetail,sellerid) values ($1,$2,$3,$4,$5) returning proid
        )
        ,ins2 as (
            insert into productoption (createdate,sku,price,proid) select $6,$7,$8,proid from ins1 returning proopid
        )
            insert into optionvalue (createdate,optionvaluename,optionvalue,proopid) select $9 , $10,$11 ,proopid from ins2;
        `
