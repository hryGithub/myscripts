#!/bin/bash

#源文件获取站点
url='http://sources.tigerft.com/java'
#url='http://47.75.125.98:8787/java'    #aws使用的地址，香港服务器代理到http://sources.tigerft.com
user='tigerft'
passwd='tigerft123!'

#nginx节点
nginxnodes=(192.168.6.100)

#nginx重载
nginx_conf_dir='/usr/local/nginx/conf'
nginx_reload='/usr/local/nginx/sbin/nginx -s reload'

#临时存放文件夹
src_dir=/data/deploy/java
pre_src_dir=/data/deploy/java_pre

#tomcat路径
tomcat_dir='/opt/app/tomcat/'

#目标路径
datetime=`date +%Y%m%d_%H%M`
sdir='/data/java'

#判断是否有$appname 参数,$appname是jenkins上的参数化构建的变量
if [ ! -n $version ]; then  
	echo "没有应用需要发布！"
	exit 0
fi


#获取app服务器列表
a=`python $(dirname $0)/apps.py $appname`

if [ ! -n "$a" ];then
	echo "找不到$appname的ip"
	exit 1
fi

#获取源文件
[ ! -d $src_dir ] && mkdir -p $src_dir

#预发布存在就从预发布拷贝文件
if [ -f $pre_src_dir/$version.war ];then
	cd $src_dir && rm -rf *
	cp $pre_src_dir/$version.war $src_dir
else
	cd $src_dir && rm -rf *
	wget -q --http-user=$user --http-passwd=$passwd -c -t5 $url/$version.war 
fi

if [ ! -f $src_dir/$version.war ];then
		echo "获取文件失败！操作终止..."
		exit 1
fi


#循环发布
for ip in ${hosts[@]};do
	ssh root@$ip "mkdir -p $sdir/$appname/$datetime"
    scp $src_dir/$version.war root@$ip:$sdir/$appname/$datetime/
    ssh root@$ip "cd $sdir/$appname/$datetime/ && jar xf $version.war"

	#包含-task的应用不需要没有nginx配置
	if [[ $appname =~ '-task' ]];then		
		#更新节点
		ssh root@$ip "ln -snf $sdir/$appname/$datetime $tomcat_dir/$appname/webapps/$appname"
		#同步配置文件
		ssh root@$ip "cd /opt/pay/config && git pull"
		#重启tomcat
		ssh root@$ip "$tomcat_dir/restart_tomcat.sh $appname"
	else
		#nginx剔除需要更新的节点
		for var in ${nginxnodes[@]};do
			ssh root@$var "sed -i '/$ip/s/^/#/' $nginx_conf_dir/upstream/$appname.conf && $nginx_reload"
		done
		#更新节点
		ssh root@$ip "ln -snf $sdir/$appname/$datetime $tomcat_dir/$appname/webapps/$appname"
		#同步配置文件
		ssh root@$ip "cd /opt/pay/config && git pull"
		#重启tomcat
		ssh root@$ip "$tomcat_dir/restart_tomcat.sh $appname"
		#从nginx中加入更新好的节点
		for var in ${nginxnodes[@]};do 
			ssh root@$var "sed -i '/$ip/s/^#//' $nginx_conf_dir/upstream/$appname.conf && $nginx_reload"				
		done
	fi
done


#构建标识
echo "[DESC]$appname:$datetime:$version"

#check service avaliable
code=$(curl -i -s -o /dev/null -m 10 --connect-timeout 10 -w %{http_code} http://soa.wex101.local/$appname/health_check)
if [ $code != 200 ];then
	#sendmail
	sender=sysinfo_local@tigerft.com
    smtp_server=smtp.exmail.qq.com
    user=sysinfo_local@tigerft.com
    password=BPg2dXrN
	to='hujian@tigerft.com'
	subject="$appname is unavaliable"
	body="$appname is unavaliable,request return $code,please check!!!"
	/usr/local/bin/sendEmail -o message-content-type=html -o message-charset=utf8 -o tls=no -f $sender -t "$to" -s $smtp_server  -xu $user -xp $password  -u "$subject" -m "$body"
fi