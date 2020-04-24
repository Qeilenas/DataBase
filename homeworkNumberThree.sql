//1.Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.

select st.name, st.surname, h.name as hobby

From students st

Inner join students_hobbies sh on st.id=sh.student_id

Inner join hobbies h on h.id=sh.hobby_id

Group by st.name, st.surname, h.name

//2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.

select st.name, st.surname, st.n_group, st.phone, st.city, st.score, st.birth_date, h.name as hobby, h.risk, age(now(), sh.date_start)

From students st

Inner join students_hobbies sh on st.id=sh.student_id

Inner join hobbies h ON h.id=sh.hobby_id

Group by st.name, st.surname, st.n_group, st.phone, st.city, st.score, st.birth_date, h.name, h.risk, age(now(), sh.date_start)

Order by Max(age(now(), sh.date_start)) desc

limit 1

//3.Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9. Select st.name,st.surname,st.score, avg(st.score),sum(h.risk) from students st inner join students_hobbies sh on st.id=sh.student_id inner join hobbies h on h.id=sh.hobby_id group by st.name,st.surname,st.score having sum(h.risk)>0.9 and st.score> (Select avg(score) from students st)

//4.Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби.

select st.name, st.surname, st.birth_date, h.name as hobby, h.risk, extract(month from age(sh.date_finish, sh.date_start)) + extract (year from age (sh.date_finish, sh.date_start)*12)

From students st

Inner join students_hobbies sh on st.id=sh.student_id

Inner join hobbies h on h.id=sh.hobby_id

where sh.date_finish is not null

//5.Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.

Select s.*

From students s

Inner join(

Select sh.student_id

From students_hobbies sh

Where sh.date_finish is null

Group by sh.student_id

Having count(*)>1) t

on s.id = t.student_id

Where extract(year from age(now(),birth_date))>20

//6.Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.

select s1.n_group, avg (s2.score)

from students as s1 join (

select distinct s.id as id, s.score as score

from students_hobbies as sh join students as s on s.id = sh.student_id

where not sh.date_finish is NULL

) as s2 on s1.id = s2.id

group by s1.n_group

//7.Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента и номер его группы.

select h.name, h.risk, s.n_group, age(sh.date_start, now())

from students as s join students_hobbies as sh on s.id = sh.student_id join hobbies as h on h.id = sh.hobby_id

where sh.date_finish is null

order by sh.date_start

limit 1

//8.Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.

select h.*

from students as s join students_hobbies as sh on s.id = sh.student_id join hobbies as h on h.id = sh.hobby_id

where s.score = (select max(score) from students)

//9.Найти все действующие хобби, которыми увлекаются троечники 2-го курса.

select h.*

from students as s join students_hobbies as sh on s.id = sh.student_id join hobbies as h on h.id = sh.hobby_id

where s.score >= 3 and s.score < 4

//10.Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.

with all_students as (

select substr(st.n_group::varchar,1,1) as course,

count (*)::real as c

from students st

group by substr(st.n_group::varchar,1,1)

), students_with_hobbies as(

select substr(st.n_group::varchar,1,1) as course,

count(distinct st.id)::real as c

from students st

inner join students_hobbies sh on st.id =sh.student_id

where sh.date_finish is null

group by substr(st.n_group::varchar,1,1)

)

select swh.c/a_s.c

from all_students a_s

inner join students_with_hobbies swh on a_s.course = swh.course

where swh.c/a_s.c >0.3

//11.Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.

select *

from (Select substr(st.n_group::varchar, 1,4) as NGROUP, count(*) as c_group

From students st

Group by substr(st.n_group::varchar, 1,4)) as st_all

Inner join (

Select substr(st.n_group::varchar, 1,4) as NGROUP, count(*) as c_good

From students st

where st.score>=4

Group by substr(st.n_group::varchar, 1,4)

Having count (*)>1) as st_gd

ON st_all.NGROUP = st_gd.NGROUP

WHERE st_all.NGROUP::integer/st_gd.NGROUP::integer>=0.6

//12.Для каждого курса подсчитать количество различных действующих хобби на курсе.

Select substr(st.n_group::varchar, 1,1) as course, count(*) as c_dh

From students st

Inner join students_hobbies sh ON st.id=sh.student_id

Inner join hobbies h ON h.id=sh.hobby_id

Where sh.date_finish is null

Group by substr(st.n_group::varchar, 1,1)

Having count (*)>1

//13.Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.

select s.surname, s.name, s.birth_date, s2.course

from students as s join (select substr(s1.n_group::varchar, 1, 1) as course, s1.id from students as s1) as s2 on s.id = s2.id

where not s.id in (select student_id from students_hobbies) and s.score = 5

order by s2.course, birth_date

//14.Создать представление, в котором отображается вся информация о студентах, которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.

select s.*

from students s

inner join students_hobbies sh on s.id=sh.student_id

where sh.date_finish is null

and extract (year from age(now(),sh.date_start))>=5

//15.Для каждого хобби вывести количество людей, которые им занимаются.

select h.id, count(sh.id)

from hobbies as h join students_hobbies as sh on h.id = sh.hobby_id

where sh.date_finish is null

group by h.id

//16.Вывести ИД самого популярного хобби.

select id

from (select h.id as id, count(sh.id) as count_student

from hobbies as h join students_hobbies as sh on h.id = sh.hobby_id

group by h.id

order by count_student desc

limit 1) as foo

//17.Вывести всю информацию о студентах, занимающихся самым популярным хобби.

select s.*

from ((select h.id as id, count(sh.id) as count_student

from hobbies as h join students_hobbies as sh on h.id = sh.hobby_id

group by h.id

order by count_student desc

limit 1) as foo join students_hobbies as sh1 on foo.id = sh1.hobby_id) join students as s on s.id = sh1.student_id

//18.Вывести ИД 3х хобби с максимальным риском.

select id

from hobbies

order by risk

limit 3

//19.Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

select *

from students s

inner join students_hobbies sh on s.id=sh.student_id

where sh.date_finish is null

order by sh.date_start

limit 10

//20.Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.

select distinct n_group

from (

select s.*

from students as s join students_hobbies as sh on s.id = sh.student_id

where sh.date_finish is null

order by sh.date_start

limit 10

) as foo

//21.Создать представление, которое выводит номер зачетки, имя и фамилию студентов, отсортированных по убыванию среднего балла.

//22.Представление: найти каждое популярное хобби на каждом курсе.

With c_hobbies AS(

Select substr(st.n_group::varchar,1,1) as course,sh.hobby_id, count(*) as c

from students st

Inner join students_hobbies sh on st.id = sh.student_id

Group by substr(st.n_group::varchar,1,1), sh.hobby_id

),max_for_course AS (

Select c_h.course, max(c) as max_c

from c_hobbies c_h

Group by c_h.course

)

Select c_h.course, c_h.hobby_id

From c_hobbies c_h

Inner join max_for_course mfc On c_h.course = mfc.course and c_h.c=mfc.max_c

//23.Представление: найти хобби с максимальным риском среди самых популярных хобби на 2 курсе.

//24.Представление: для каждого курса подсчитать количество студентов на курсе и количество отличников.

//25.Представление: самое популярное хобби среди всех студентов.

//26.Создать обновляемое представление.

CREATE OR REPLACE VIEW public.active_hobbies AS

select sh.student_id

from students_hobbies sh

where sh.date_finish IS NULL

Group by sh.student_id

having count(*) > 1;

//27.Для каждой буквы алфавита из имени найти максимальный, средний и минимальный балл. (Т.е. среди всех студентов, чьё имя начинается на А (Алексей, Алина, Артур, Анджела) найти то, что указано в задании. Вывести на экран тех, максимальный балл которых больше 3.6

//28.Для каждой фамилии на курсе вывести максимальный и минимальный средний балл. (Например, в университете учатся 4 Иванова (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 4.1, 4, 3.8 соответственно, а 4 Иванов учится на 3 курсе и имеет балл 4.5. На экране должно быть следующее: 2 Иванов 4.1 3.8 3 Иванов 4.5 4.5

//29.Для каждого года рождения подсчитать количество хобби, которыми занимаются или занимались студенты.

//30.Для каждой буквы алфавита в имени найти максимальный и минимальный риск хобби.

Select substr(st.name, 1, 1), max(h.risk), min(h.risk)

From students st

Inner join students_hobbies sh ON st.id = sh.student_id

Inner join hobbies h on h.id = sh.hobby_id

Group by substr(st.name, 1 , 1)

//31.Для каждого месяца из даты рождения вывести средний балл студентов, которые занимаются хобби с названием «Футбол»

//32.Вывести информацию о студентах, которые занимались или занимаются хотя бы 1 хобби в следующем формате: Имя: Иван, фамилия: Иванов, группа: 1234

Select contact ('Имя: ', st.name, ' ' , 'Фамилия: ', st.surname, ' ' , 'Группа: ', st.n_group)

From students st

Inner join students_hobbies sh on st.id=sh.student_id

//33.Найдите в фамилии в каком по счёту символа встречается «ов». Если 0 (т.е. не встречается, то выведите на экран «не найдено».

Select st.surname,

Case when position('ов' in st.surname )=0 then 'не найдено'

else position('ов' in st.surname )::varchar End as position

From students st

//34.Дополните фамилию справа символом # до 10 символов.

Select RPAD(st.surname,10,'#')

From students st

//35.При помощи функции удалите все символы # из предыдущего запроса.

Select TRIM(trailing'#'from RPAD(st.surname,10,'#'))

From students st

//36.Выведите на экран сколько дней в апреле 2018 года.
