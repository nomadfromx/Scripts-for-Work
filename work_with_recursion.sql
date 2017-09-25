with test_table as
(select 1 id, null pid, 'Россия' title from dual
union all
select 2 id, 1 pid, 'Воронеж' title from dual
union all
select 20 id, 1 pid, 'Лиски' title from dual
union all
select 21 id, 20 pid, 'ЛискиПресс' title from dual
union all
select 4 id, 1 pid, 'Москва' title from dual
union all
select 5 id, 2 pid, 'ООО "Рога и копыта"' title from dual
union all
select 6 id, 5 pid, 'Главный офис' title from dual
union all
select 7 id, 5 pid, 'Офис 1' title from dual
union all
select 8 id, 5 pid, 'Офис 2' title from dual
union all
select 9 id, 8 pid, 'Сервер 1' title from dual
union all
select 10 id, 4 pid, 'Тверь' title from dual
union all
select 11 id, 10 pid, 'Аксенчер' title from dual
-- add a loop
union all
select 2 id, 9 pid, 'Воронеж' title from dual)

select level, id, pid, title, sys_connect_by_path(title, '/') as Path,
connect_by_isleaf as isleaf,
prior title as parent,
connect_by_root title as root,
connect_by_iscycle as iscycle
from test_table
--where id = 9
start with pid is null
connect by nocycle prior id = pid
order siblings by title
