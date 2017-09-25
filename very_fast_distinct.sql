CREATE INDEX XXVIP.XX_1C_SALES_X1 ON XXVIP.XX_1C_SALES (ITEM_CATEGORY) TABLESPACE XXVIPX;
CREATE INDEX XXVIP.XX_1C_STOCK_X1 ON XXVIP.XX_1C_STOCK (ITEM_CATEGORY) TABLESPACE XXVIPX;

CREATE INDEX XXVIP.XX_1C_SALES_X2 ON XXVIP.XX_1C_SALES (STORE_TYPE) TABLESPACE XXVIPX;
CREATE INDEX XXVIP.XX_1C_STOCK_X2 ON XXVIP.XX_1C_STOCK (STORE_TYPE) TABLESPACE XXVIPX;



with 
t_unique1(store_type) as (
select min(store_type) from xx_1c_sales t1
union all
select (select min(store_type) from xx_1c_sales t1 where t1.store_type > t.store_type)
from t_unique1 t
where store_type is not null
),
t_unique2(store_type) as (
select min(store_type) from xx_1c_stock t1
union all
select (select min(store_type) from xx_1c_stock t1 where t1.store_type > t.store_type)
from t_unique2 t
where store_type is not null
)
select store_type from t_unique1 where store_type is not null
union
select store_type from t_unique2 where store_type is not null


with 
t_unique1(item_category) as (
select min(item_category) from xx_1c_sales t1
union all
select (select min(item_category) from xx_1c_sales t1 where t1.item_category > t.item_category)
from t_unique1 t
where item_category is not null
),
t_unique2(item_category) as (
select min(item_category) from xx_1c_stock t1
union all
select (select min(item_category) from xx_1c_stock t1 where t1.item_category > t.item_category)
from t_unique2 t
where item_category is not null
)
select item_category from t_unique1 where item_category is not null
union
select item_category from t_unique2 where item_category is not null
