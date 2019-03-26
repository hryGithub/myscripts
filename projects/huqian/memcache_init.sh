#!/bin/bash

cmd='/usr/local/memcached-1.5.6/bin/memcached'

for port in {30001..30027};do
    $cmd -d -u memcached -m 100 -p $port -c 10240
done

####Supervisor-监控进程并自动重启(后台运行的程序不能使用)
#安装
#yum install python-setuptools 
#easy_install supervisor
#编辑配置文件/etc/supervisord.conf 
#[program:memcached30001]
#command = /usr/local/memcached-1.5.6/bin/memcached   -u memcached -m 100 -p 30001 -c 10240  //需要执行的命令
#autostart=true    //supervisor启动的时候是否随着同时启动
#autorestart=true   //当程序跑出exit的时候，这个program会自动重启
#startsecs=3  //程序重启时候停留在runing状态的秒数
#