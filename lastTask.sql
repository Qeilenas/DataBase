-- task ¹ 1
select s.date_creation, s.city
from shop as s
where city = 'Ïîìïåè'and date_creation > now()

-- task ¹ 2
select sw.start_work, sw.finish_work, s.name
from schedule_works as sw, shop as s, employee_shop as es
where cast (s.name AS varchar) like 'Ôåÿ' and s.id = es.shop_id and sw.start_work is not null

-- task ¹ 3
SELECT cl.id, cl.name, cl.surname, cl.middle_name, extract(month from age(ac.date_buy)) as day
FROM client as cl

INNER JOIN product_accounting as pa ON cl.id=pa.client_id
INNER JOIN accounting as ac ON pa.accounting_id=ac.id
WHERE pa.receipt >= 10000 and age(ac.date_buy, '1999-01-01') > age(now(), '1999-01-16')

ORDER BY cl.id, cl.name, cl.surname, cl.middle_name, extract(month from age(ac.date_buy))

-- task ¹ 4
with funcOne as(select ac.id, sum(ac.amount*ac.price) as buy,count(*)::real as tmp1
from accounting as ac

where(now()::date-ac.date_buy::date)*24<=240
Group By ac.id ), funcTwo as(select count(*)::real as tmp2 from accounting as ac)

select funcOne.buy , client.name
from funcOne, client, funcTwo

where client.id = funcOne.id

order by funcOne.buy desc
limit (select count(*)/10 from client )

-- task ¹ 5
with func as(SELECT cl.id, cl.name, cl.surname, cl.middle_name, MAX(pa.receipt) as receipt
FROM client as cl

INNER JOIN product_accounting as pa ON cl.id=pa.client_id
INNER JOIN accounting as ac ON pa.accounting_id=ac.id

WHERE (now()::date-ac.date_buy::date)*24<=240

GROUP BY cl.id, cl.name, cl.surname, cl.middle_name, pa.receipt
having pa.receipt = MAX(pa.receipt)
ORDER BY pa.receipt desc
LIMIT 1)

select avg(func.receipt)
from func

-- task ¹ 6
SELECT pat.id, pat.attribute, One, Two, Three, Fo
FROM product_attribute pat


LEFT JOIN (SELECT ac.amount, pa.product_name_id as product_id
From accounting ac
INNER JOIN product_accounting pa ON pa.accounting_id = ac.id
WHERE ac.date_buy> now()-interval '7 days') as One ON pat.id=One.product_id


LEFT JOIN (SELECT ac.amount, pa.product_name_id as product_id
From accounting ac
INNER JOIN product_accounting pa ON pa.accounting_id = ac.id
WHERE ac.date_buy> now()-interval '14 days' and ac.date_buy < now()-interval '7 days') as Two ON pat.id=Two.product_id


LEFT JOIN (SELECT ac.amount, pa.product_name_id as product_id
From accounting ac
INNER JOIN product_accounting pa ON pa.accounting_id = ac.id
WHERE ac.date_buy> now()-interval '21 days' and ac.date_buy < now()-interval '14 days') as Three ON pat.id=Three.product_id


LEFT JOIN (SELECT ac.amount, pa.product_name_id as product_id
From accounting ac
INNER JOIN product_accounting pa ON pa.accounting_id = ac.id
WHERE ac.date_buy> now()-interval '28 days' and ac.date_buy < now()-interval '21 days') as Fo ON pat.id=Fo.product_id


ORDER BY pat.id

-- task ¹ 7
with a as(select distinct p.product_name_id,

case
when acc.date_buy < now() and acc.date_buy > (now()::date - integer '7')
then (count(p.*))
else 0
end as one,

case
when acc.date_buy < now()::date - integer '7' and acc.date_buy > now()::date - integer '14'
then count(p.*)
else 0
end as two,

case
when acc.date_buy < now()::date - integer '14' and acc.date_buy > now()::date - integer '21'
then count(p.*)
else 0
end as three,

case
when acc.date_buy < now()::date - integer '21' and acc.date_buy > now()::date - integer '28'
then count(p.*)
else 0
end as fo

from product_accounting p, accounting acc
where acc.id = p.accounting_id
group by p.product_name_id, acc.date_buy)


select product_name_id, (one + two + three + fo) as summ,
p.quantity_stock,

case
when (one + two + three + fo) > p.quantity_stock
then (one + two + three + fo) - p.quantity_stock
else 0
end

from a

inner join product_name p on a.product_name_id = p.id
group by product_name_id, summ, p.quantity_stock

-- task ¹ 8
select em.name, em.surname,sw.start_work,sw.finish_work
from employee as em, schedule_works as sw
where sw.id=em.schedule_works_id and finish is not null

-- task ¹ 9
SELECT two_last.two_last, one_last.one_last, now.now, one_next.one_next, two_next.two_next
FROM food as f

LEFT JOIN (SELECT f.id as id, ABS((ph.old_price-ph.new_price)*100)/ph.old_price::real as two_last
FROM food as f
INNER JOIN price_history ph ON ph.product_id=f.id
WHERE ph.date_changes > now() - interval '14 days' and ph.date_changes < now()-interval '7 days') as two_last ON two_last.id = f.id

LEFT JOIN (SELECT f.id as id, ABS((ph.old_price-ph.new_price)*100)/ph.old_price::real as one_last
FROM food as f
INNER JOIN price_history ph ON ph.product_id=f.id
WHERE ph.date_changes > now() - interval '7 days') as one_last ON one_last.id = f.id

LEFT JOIN (SELECT f.id as id, ph.new_price as now
FROM food as f
INNER JOIN price_history ph ON ph.product_id=f.id) as now ON now.id=f.id

LEFT JOIN (SELECT f.id as id, ABS((ph.new_price-ph.new_price)*100)/ph.new_price::real as one_next
FROM food as f
INNER JOIN price_history ph ON ph.product_id=f.id
WHERE ph.date_changes < now() + interval '7 days') as one_next ON one_next.id = f.id

LEFT JOIN (SELECT f.id as id, ABS((ph.new_price-ph.new_price)*100)/ph.new_price::real as two_next
FROM food as f
INNER JOIN price_history ph ON ph.product_id=f.id
WHERE ph.date_changes < now() + interval '14 days' and ph.date_changes > now()+interval '7 days') as two_next ON two_next.id = f.id

-- task ¹ 10
select cl.id, cl.name, ac.date_buy, EXTRACT(week FROM ac.date_buy)
from client as cl, product_accounting as pa, accounting as ac
where cl.id= pa.id and ac.id = pa.id

-- task ¹ 11
delete from only client where phone = '';     -- and where mail = “ “;
delete from client where phone = '' ';    --  and  where mail = “ “;

-- task ¹ 12
with funcOne as(select em.id ,em.accepted
from employee as em
where em.accepted = (select max(accepted) from employee)),

funcTwo as(select sup.name as supplier,sh.name as shop, em.id ,em.surname as employee_surname
from supplier as sup, employee as em, shop as sh
where em.id = sup.employee_id and sup.shop_id = sh.id)

select *
from funcOne, funcTwo
where funcOne.id = funcTwo.id

-- task ¹ 13
with funcOne as
(select ps.id, ps.costs::real as price_product
from product_shop as ps ),

funcTwo as
(select ss.id, ss.price::real as price_supplier
from shop_supplier as ss )

select (funcOne.price_product-funcTwo.price_supplier)/funcTwo.price_supplier*100 as relative ,
funcOne.price_product-funcTwo.price_supplier as absolute
from funcOne, funcTwo
where funcOne.id = funcTwo.id

-- task ¹ 14
with clear_income as
(with outcome as (select ss.id, ss.price::real as outcome
from shop_supplier as ss),

income as (select ps.id, ps.costs::real as income
from product_shop as ps )

select outcome.id outcome_id, income.id as income_id, income.income-outcome.outcome as clear_income, outcome.outcome
from outcome, income
where outcome.id = income.id), shop as(select s.id as shop_id from shop as s)

select *
from clear_income, shop
where clear_income.income_id = shop.shop_id and clear_income.outcome_id = shop.shop_id

-- task ¹ 15
ALTER TABLE employee ADD COLUMN salary integer ;

update employee set salary = 30000 where id = 1;
update employee set salary = 30000 where id = 2;
update employee set salary = 30000 where id = 3;
update employee set salary = 30000 where id = 4;
update employee set salary = 30000 where id = 5;
update employee set salary = 30000 where id = 6;
update employee set salary = 30000 where id = 7;
update employee set salary = 30000 where id = 8;
update employee set salary = 30000 where id = 9;
update employee set salary = 30000 where id = 10;

alter table employee alter column salary set not null;

