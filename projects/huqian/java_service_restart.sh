#!/bin/bash

datetime=`date "+%Y/%m/%d %H:%M:%S"`
#获取app服务器列表
if [ "$env"x = prex ];then
        appfile=/data/scripts/otc_app_pre.py
elif [ "$env"x = prex ];then
        appfile=/data/scripts/otc_app.py
else
        echo "环境信息不正确，请检查配置!"
        exit 1
fi

a=`python $appfile $appname`

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
echo "[DESC]$datetime重启$env环境的$appname应用"
