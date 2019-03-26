#!/bin/bash

#appname='acs'
#hostip='192.168.9.162'
#src=$WORKSPACE/web/target
br=`echo $branch | sed 's@origin/@@g'`
gitid=`git rev-parse  --short HEAD`
version="${appname}-${br}-${gitid}"
echo "[DESC]version:$version.war" #标识jenkins构建记录
mv $src/$appname.war $src/$version.war
#部署到远程tomcat
ssh root@$hostip "rm -rf /opt/app/tomcat/$appname/webapps/$appname/*"
scp $src/$version.war root@$hostip:/opt/app/tomcat/$appname/webapps/$appname/
ssh root@$hostip "cd /opt/app/tomcat/$appname/webapps/$appname/ && jar xf $version.war"
ssh root@$hostip "cd /opt/pay/config && git pull && /opt/app/tomcat/restart_tomcat.sh $appname"
#复制到远程nginx服务器
scp -r $src/$version.war scm@120.55.49.120:/opt/app/soures/java/

#更新文件列表
ssh scm@120.55.49.120 "ls /opt/app/sources/java|grep ".war$"|sed 's@.war@@g' > /opt/app/sources/java/.file.txt"