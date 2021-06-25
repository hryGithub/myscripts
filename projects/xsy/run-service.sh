#!/bin/sh
JAVA_HOME="/usr/java/jdk1.8.0_271-amd64"

ENV=prod

SERVICE=$1

APP_HOME=/data/app/$1

APP_MAINCLASS="com.xiaoshouyi.`echo $1|tr '-' '.'`.Bootstrap"

CLASSPATH=$APP_HOME/classes

CLASSPATH="$CLASSPATH":"$APP_HOME"/lib/*

LOCAL_IP=`/usr/sbin/ifconfig eth0|grep inet|grep -v inet6|awk '{print $2}'|tr -d "addr:"s`

PORT=`grep 'server.port=' $APP_HOME/classes/bootstrap.properties|cut -d '=' -f 2`

NACOS_NODES='10.150.10.8:8848,10.150.10.2:8848'

array=(`echo $NACOS_NODES|tr ',' ' '`)

JAVA_OPTS="-Xms2g -Xmx2g -Xmn256m -XX:MaxMetaspaceSize=512m -Dnacos.server.addr=$NACOS_NODES -Dnacos.namespace=$ENV"

stat=0
psid=0

checkuser() {
    user=`whoami`
    if [ "$user"x != xsyx ];then
        echo "================================"
        echo "error: current user is "$user", you must run scrits as user xsy!"
        echo "================================"
        exit 1
    fi
}
checkpid() {
   javaps=`$JAVA_HOME/bin/jps -l | grep $APP_MAINCLASS`

   if [ -n "$javaps" ]; then
      psid=`echo $javaps | awk '{print $1}'`
   else
      psid=0
   fi
}

deregister(){
   echo "begin to deregister from nacos server..."
   for s in ${array[@]};do
      rs=`curl -s -X PUT "http://$s/nacos/v1/ns/instance?serviceName=$SERVICE&ip=$LOCAL_IP&port=$PORT&namespaceId=$ENV&groupName=REGISTER&enable=false"`
      if [ $rs = 'ok' ];then
         echo "deregister from nacos server successfully!"
         break
      fi
   done
   
}
checkstat() {
   for s in ${array[@]};do 
      rs=`curl -s "http://$s/nacos/v1/ns/instance?serviceName=$SERVICE&ip=$LOCAL_IP&port=$PORT&namespaceId=$ENV&groupName=REGISTER"`
      match=`echo $rs|grep '"healthy":true'`
      if [[ $match ]];then
         stat=1
         echo "register into nacos server successfully!"
         break
      fi
   done
}

start() {
   checkuser
   checkpid
   if [ $psid -ne 0 ]; then
      echo "================================"
      echo "warn: $APP_MAINCLASS already started! (pid=$psid)"
      echo "================================"
   else
      echo "Starting $APP_MAINCLASS ..."
      cd $APP_HOME
      nohup $JAVA_HOME/bin/java $JAVA_OPTS -classpath $CLASSPATH $APP_MAINCLASS >/dev/null 2>&1 &
                     

      checkpid
      if [ $psid -ne 0 ]; then
         sleep 20
         checkstat
         if [ $stat != 0 ];then
            echo "start $APP_MAINCLASS successfuly! (pid=$psid) [OK]"
         else
            echo "register into nacos server failed!"
            exit 1
         fi
      else
         echo "start $APP_MAINCLASS [Failed]"
         exit 1
      fi
   fi
}

stop() {
   checkuser
   checkpid
   deregister   
   if [ $psid -ne 0 ]; then
      echo "Stopping $APP_MAINCLASS ...(pid=$psid) "
      #su - $RUNNING_USER -c "kill -9 $psid"
      kill -15 $psid
      sleep 10
      checkpid
      if [ $psid -ne 0 ]; then
         echo "beggin to stop  $APP_MAINCLASS forcedly ...(pid=$psid)"
         kill -9 $psid
      fi
   else
      echo "================================"
      echo "warn: $APP_MAINCLASS is not running"
      echo "================================"
   fi
}

status() {
   checkpid
   if [ $psid -ne 0 ];  then
      echo "$APP_MAINCLASS is running! (pid=$psid)"
   else
      echo "$APP_MAINCLASS is not running"
   fi
}

info() {
   echo "System Information:"
   echo "****************************"
   echo `uname -a`
   echo
   echo "JAVA_HOME=$JAVA_HOME"
   echo `$JAVA_HOME/bin/java -version`
   echo
   echo "APP_HOME=$APP_HOME"
   echo "APP_MAINCLASS=$APP_MAINCLASS"
   echo "****************************"
}

case "$2" in
   'start')
      start
      ;;
   'stop')
     stop
     ;;
   'restart')
     stop
     start
     ;;
   'status')
     status
     ;;
   'info')
     info
     ;;
  *)
echo "Usage: $0 $1 {start|stop|restart|status|info}"
exit 1
esac
exit 0
