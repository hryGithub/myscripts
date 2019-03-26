#!/bin/bash

#源文件获取站点
url='http://sources.tigerft.com/front'
#url='http://47.75.66.166:8787/front'    //aws使用的地址，香港服务器代理到http://sources.tigerft.com
user='tigerft'
passwd='tigerft123!'

#nginx节点
if [ "$1"x = prodx ];then
	nginxnodes=(192.168.6.100)
else 
	nginxnodes=(192.168.1.30)
fi

#nginx重载
nginx_conf_dir='/usr/local/nginx/conf'
nginx_reload='/usr/local/nginx/sbin/nginx -s reload'

#临时存放文件夹
src_dir=/data/deploy/front

#路径
front_dir='/data/repos/'

#目标路径
datetime=`date +%Y%m%d_%H%M`
sdir='/data/front'

#判断是否有$appname 参数,$appname是jenkins上的参数化构建的变量
if [ ! -n $appname ]; then  
	echo "没有应用需要发布！"
	exit 0
fi

#获取源文件
[ ! -d $src_dir ] && mkdir -p $src_dir
cd $src_dir && rm -rf *
wget -q --http-user=$user --http-passwd=$passwd -c -t5 $url/$appname.tar.gz 

if [ ! -f $src_dir/$appname.tar.gz ];then
	echo "获取文件失败！操作终止..."
	exit 0
fi


#循环发布
for ip in ${nginxnodes[@]};do
	#更新节点
	ssh root@$ip "mkdir -p $sdir/$appname/$datetime"
    scp $src_dir/$appname.tar.gz root@$ip:$sdir/$appname/$datetime/
    ssh root@$ip "cd $sdir/$appname/$datetime/ && tar zxf $appname.tar.gz"
    ssh root@$ip "ln -snf $sdir/$appname/$datetime $front_dir/$appname"
	#node服务需要单独执行命令
	if [ $appname = 'pc-exc' -o $appname = 'h5-market' ];then
		ssh root@$ip "source /etc/profile && cd  $front_dir/$appname && pm2 delete $appname && pm2 start pm2.config.js --env production || pm2 start pm2.config.js --env production"
		/bin/bash /data/scripts/flush_cdn.sh $appname
	fi
done


