#!/bin/bash
command1="/usr/bin/ssmgr -c /data/ssmgr/ss.yml"
command2="/usr/bin/ssmgr -c /data/ssmgr/webgui.yml"
monitor(){
pid=`ps -ef|grep "$*"|grep -v grep|awk '{print $2}'`
if [ "$pid" = "" ];then 
	echo "begin to restart "
	nohup $* >/dev/null 2>&1 &
fi
}

monitor $command1
monitor $command2
