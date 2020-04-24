/*

select count(s.n_group ),s.n_group
from students s
group by s.n_group

select max(s.score), s.n_group
from students s
group by s.n_group

select count(name), s.name
from students s
group by s.name

select s.n_group, AVG(s.score)
from students s
group by s.n_group

select s.n_group, max(s.score)
from students s
group by s.n_group
limit 1

select s.n_group, AVG(s.score)
from students s
group by s.n_group, s.score
having s.score<=3.5

select s.n_group, count(*), max(s.score), min(s.score),AVG(s.score)
from students s
group by s.n_group

select s.name,s.score
from students s
where s.score =(select max (s.score) from students s)
select s.n_group,s.name, avg(s.score) from students s where cast (s.n_group AS varchar) like '2074' and s.score=(select max(s.score) from students s) Group by s.n_group, s.name

*/

















