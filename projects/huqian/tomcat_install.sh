#!/bin/bash
set -e
#需要传递参数
if [ $# != 2 ];then
        echo "参数错误"
        echo "e.g:$0 {appname} port"
        exit 1
fi

tomcat_path='/opt/app/tomcat'

if [ ! -f $tomcat_path/tomcat8.tar.gz ];then
    echo "$tomcat_path/tomcat8.tar.gz doesn't exit!"
    exit 1
fi
appname=$1
port=$2

if [ -d $tomcat_path/$appname ];then
    echo "error！$appname目录已经存在!"
    exit 1
fi

#解压重命名
cd $tomcat_path 
tar zxf tomcat8.tar.gz 
mv apache-tomcat-8.5.29 $appname
mkdir $tomcat_path/$appname/webapps/$appname -p
#替换配置文件
sed -i "s@8005@`expr $port - 1000`@g" $tomcat_path/$appname/conf/server.xml
sed -i "s@8080@$port@g" $tomcat_path/$appname/conf/server.xml
sed -i "s@8009@`expr $port + 1000`@g" $tomcat_path/$appname/conf/server.xml

echo "$appname 已经完成初始化，目录为$tomcat_path/$appname!"