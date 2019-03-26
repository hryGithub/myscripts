#!/bin/bash

datetime=`date "+%Y/%m/%d %H:%M:%S"`
#获取app服务器列表
a=`python /data/scripts/otc_app.py $appname`

if [ ! -n "$a" ];then
        echo "找不到$appname的ip"
        exit 1
fi

OLD_IFS="$IFS"
IFS=","
arr=($a)
IFS="$OLD_IFS"

for ip in ${arr[@]};do
        ssh root@$ip "/opt/app/tomcat/restart_tomcat.sh $appname"
done

#JENKINS标识
echo "[DESC]$appname restart at $datetime"
