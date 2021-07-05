#!/bin/bash
# 查询不包含某些字段的表
db_addr=10.150.10.7
db_user=root
export MYSQL_PWD=

dbnames="account_db,basement_db,basesku_db,,data_exchange_db,ecommerce_db,member_db,message_db,miniapp_db,order_db,pay_db,product_db"

array=(`echo $dbnames|tr ',' ' '`)

for db in ${array[@]};do
    sql="select table_name from information_schema.tables where table_schema='$db' and table_name not in (select DISTINCT  table_name from information_schema.COLUMNS where COLUMN_NAME in ('created_at','created_by','updated_at','updated_by','last_updated_at'));
"
    rs=`mysql -u$db_user -h$db_addr -e "$sql" |grep -v table_name`
    echo "$db:$rs" >> rs.txt
done
