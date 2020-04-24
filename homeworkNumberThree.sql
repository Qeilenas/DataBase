select st.name, st.surname, h.name, h.risk, st.score
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id;

select st.name, st.surname, h.name
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where sh.date_finish-sh.date_start=(select max(date_finish-date_start) from students_hobbies);

select st.name, st.surname, avg(st.score), st.score
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where st.score>(select avg(score) from students)
group by st.name, st.surname, st.score
having sum(h.risk)>0.9;

select st.name, st.surname, h.name, sh.date_finish-sh.date_start, sh.date_start, sh.date_finish
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where sh.date_finish is not null;

select st.*
from students st
inner join (select sh.student_id
from students_hobbies sh
where sh.date_finish is null
group by sh.student_id
having count(*)>1) ah on st.id =ah.student_id
where extract(year from age(now(),st.birth_date))>=20;

select st.n_group, avg(st.score)
from students st left join students_hobbies sh on st.id=sh.student_id
group by st.n_group;

select h.name, h.risk, st.id, st.n_group
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where sh.date_start=(select max(h.date_start) from students_hobbies h) and sh.date_finish is null;

select h.name
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where st.score=(select max(st.score) from students st);

select h.name
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where sh.date_start is null and st.score<=3;

select count(h.name), st.n_group
from students st inner join students_hobbies sh on st.id = sh.student_id inner join hobbies h on sh.hobby_id = h.id
where sh.date_finish is null
group by st.n_group;

select t2.hobby_id
from
(
select sh.hobby_id, count(sh.hobby_id) as t
from students_hobbies sh
group by sh.hobby_id
order by t desc
limit 1
) t2;


//только 12 запросов
