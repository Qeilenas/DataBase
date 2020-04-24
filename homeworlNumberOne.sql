/*
Select *
from students s

where n_group = 2074

where score between 4 and 4.5

Where Cast (s.n_group as varchar) like '2___'

Order by s.n_group desc , s.name

where s.score > 4
order by s.score desc

Select h.name, h.risk
from hobbies h
where h.name in ('Футбол','Хоккей')

Select sh.student_id , sh.hobby_id , sh.date_start, sh.date_finish
from students_hobbies sh
where sh.date_start between '2015-09-02' and '2018-02-18' and sh.date_finish is not null

Select *
from students s
where s.score > 4.5
order by s.score desc

Select *
from students s
where s.score >= 4.5
order by s.score desc
limit 5

Select 
from hobbies h
 SELECT h.name , h.risk
 CASE 
 WHEN h.risk < 2 THEN 'Это 1!!!'
 WHEN h.risk > 2 & h.risk > 4 THEN 'Это 2!!11'
 ELSE 'Это не 1 и 2!!!!'
END

select *
from hobbies h
order by h.risk desc
fetch first 3 rows only

*/



Select sh.student_id , sh.hobby_id , sh.date_start, sh.date_finish
from students_hobbies sh
where sh.date_start between '2015-09-02' and '2018-02-18' and sh.date_finish is not null

