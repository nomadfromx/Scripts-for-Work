create table TABLE_A
(
  REC_ID NUMBER,
  COL1   VARCHAR2(200),
  COL2   VARCHAR2(200),
  COL3   VARCHAR2(200)
);

create table TABLE_B
(
  REC_ID NUMBER,
  TYPE   VARCHAR2(30),
  VALUE  VARCHAR2(200)
);

declare
  v_val table_b.value%type;
begin
  for cur_rec_id in( select rec_id from table_a ) loop
    for cur_columns in( select column_name 
                          from all_tab_columns
                         where owner = user
                           and table_name = 'TABLE_A'
                           and column_name <> 'REC_ID' ) loop
      execute immediate 'select '||cur_columns.column_name||' from table_a where rec_id = :1' 
                   into v_val
                  using cur_rec_id.rec_id;  
      if v_val is not null then
        insert into table_b
          (rec_id, type, value)
        values
          (cur_rec_id.rec_id, lower(cur_columns.column_name), v_val);        
      end if;                                    
    end loop; -- cur_columns
  end loop; -- cur_rec_id
end;   
/
