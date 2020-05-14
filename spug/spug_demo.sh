#!/bin/bash
set -e

if [ $# != 4 ];then
    echo "参数错误"
    echo "e.g:$0 SPUG_APP_NAME SPUG_RELEASE SPUG_DEPLOY_TYPE SPUG_VERSION "
    exit 1
fi 
SPUG_APP_NAME=$1
SPUG_RELEASE=`echo $2 | sed "s/$(printf %b '\u200b')//g"`
SPUG_DEPLOY_TYPE=$3
SPUG_VERSION=$4

url=http://xxx.xxx.xxx.xxx:xxx/java
desc_dir=/data/java/$SPUG_APP_NAME/$SPUG_VERSION
deploy_dir=/opt/app/tomcat/$SPUG_APP_NAME/webapps/$SPUG_APP_NAME

if [ $SPUG_DEPLOY_TYPE = 1 ];then
    echo "$SPUG_APP_NAME开始发布，版本号为$SPUG_RELEASE..."
    mkdir -p $desc_dir
    cd $desc_dir 
    wget -q -c -t5 $url/$SPUG_APP_NAME-$SPUG_RELEASE.war
    jar -xf $SPUG_APP_NAME-$SPUG_RELEASE.war
    ln -snf $desc_dir $deploy_dir
    /opt/app/tomcat/restart_tomcat.sh $SPUG_APP_NAME
elif [ $SPUG_DEPLOY_TYPE = 2 ];then
    echo "$SPUG_APP_NAME开始回滚，版本号为$SPUG_RELEASE..."
    ln -snf $desc_dir $deploy_dir
    /opt/app/tomcat/restart_tomcat.sh $SPUG_APP_NAME
fi