with t as (
  select 300 a,305 b from dual union all
  select 305,310 from dual union all
  select 150,151 from dual union all
  select 152,154 from dual union all
  select 156,157 from dual 
)

select * from (
    select 
         nvl(sg,lag(sg) over(order by nvl(sg,eg))) sg,
         eg
    from (
         select 
             a,
             b,
             case 
                when 
                 a-1>max(b) over(order by a asc,b desc rows between unbounded preceding and 1 preceding)
                 or max(b) over(order by a asc,b desc rows between unbounded preceding and 1 preceding) is null
                then a
             end sg,
             case 
                when 
                 (
                 lead(a) over(order by a asc,b desc)
                 >
                 1+max(b) over(order by a asc,b desc rows between unbounded preceding and current row)
                 )
                 or lead(a) over(order by a asc,b desc) is null
                then max(b) over(order by a asc,b desc rows between unbounded preceding and current row)
             end eg
         from t
    )
    where sg is not null 
    or eg is not null
) where eg is not null
