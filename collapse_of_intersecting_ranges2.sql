with intervals (b, e) as (
                                     select  1,  4 from dual
                           union all select  3,  8 from dual
                           union all select  5,  8 from dual
                           union all select  5, 10 from dual
                           union all select 11, 13 from dual
                           union all select 15, 17 from dual
                           union all select 12, 18 from dual
                           union all select 16, 20 from dual                 
                         )
--
-- Основной запрос:
select min(b) as x_b, max(e) as x_e
  from (
         select b, e, sum(sog) over(order by b,e) as grp_id
           from (
                  select b, e, 
                         case 
                           when b <= max(e) over(order by b, e 
                                                  rows between unbounded preceding
                                                           and 1 preceding) 
                             then 0 
                           else 1 
                         end as sog -- sog = start_of_group :)
                    from intervals
                )
       )
group by grp_id
order by 1;
