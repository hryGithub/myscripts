#!/bin/bash

#源文件获取站点
url='http://sources.tigerft.com/go'
user='tigerft'
passwd='tigerft123!'


#host  api只运行在第一台
hosts=(192.168.2.204 192.168.7.208)

#临时存放文件夹
src_dir=/data/deploy/go

#blockchain路径
block_dir='/opt/app/blockchain/'

#目标路径
datetime=`date +%Y%m%d_%H%M`
sdir='/data/go'

#判断是否有$appname 参数,$appname是jenkins上的参数化构建的变量
if [ ! -n $appname ]; then  
	echo "没有应用需要发布！"
	exit 0
fi

#获取源文件
[ ! -d $src_dir ] && mkdir -p $src_dir
cd $src_dir && rm -rf *
wget -q --http-user=$user --http-passwd=$passwd -c -t5 $url/$appname.x
if [ ! -f $src_dir/$appname.x ];then
	echo "获取文件失败！操作终止..."
	exit 1
fi

#循坏发布
for host in ${hosts[@]};do 
    ssh root@$host "mkdir -p $sdir/$appname/$datetime"
    scp $src_dir/$appname.x root@$host:$sdir/$appname/$datetime/
	ssh root@$host "chmod +x $sdir/$appname/$datetime/$appname.x && ln -snf $sdir/$appname/$datetime/$appname.x $block_dir/$appname/$appname.x"
	ssh -fn root@$host  "/opt/app/blockchain/$appname/restart_service.sh"
	
	if [[  $appname =~ 'btcapiserver' || $appname =~ 'usdtapiserver' ]];then
		continue
	fi
done





