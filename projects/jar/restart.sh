#!/bin/bash --login

set -e
fpath=/applications/lllw
package="lllw-admin-web.jar"
old_pid=`ps -ef|grep "$fpath/$package"|grep -v grep|awk '{print $2}'`
#重启
if [ "$old_pid" != '' ];then
        echo "service is running,pid is $old_pid"
        echo "begin to stop service(pid is $old_pid)..."
        kill -9 $old_pid
        echo "$old_pid stoped, "
        sleep 3
fi
echo "begin to start service..."
nohup java -jar -Xms512m -Xmx512m $fpath/$package --spring.profiles.active=test > $fpath/nohup.out 2>&1 &

sleep 3

new_pid=`ps -ef|grep "$fpath/$package"|grep -v grep|awk '{print $2}'`
echo "service is running,pid is $new_pid"