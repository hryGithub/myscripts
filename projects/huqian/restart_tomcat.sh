#!/bin/bash
set -e
#需要传递参数
if [ $# != 1 ];then
        echo "参数错误"
        echo "e.g:$0 {appname}"
        exit 1
fi

start_cmd="su tiger /opt/app/tomcat/$1/bin/startup.sh"
#获取tomcat进程id
old_pid=`ps -ef|grep "/opt/app/tomcat/$1/"|grep -v grep|awk '{print $2}'`

#重启
if [ "$old_pid" != '' ];then
    echo "$1 is running,pid is $old_pid"
    echo "begin to stop $1(pid is $old_pid)..."
    kill -9 $old_pid
    echo "$old_pid stoped, "
    sleep 3
fi
#清除日志
rm -rf /opt/app/tomcat/$1/logs/*

#同步配置文件
cd /opt/pay/config && git pull

$start_cmd 

new_pid=`ps -ef|grep "/opt/app/tomcat/$1/"|grep -v grep|awk '{print $2}'`
echo "$1 is running,pid is $new_pid"