#!/bin/sh

#crontab示例
#0 0 * * * /bin/bash cut_log.sh

rq=`date -d "yesterday" +%Y%m%d`
dir=/opt/app/blockchain
logs=("btc-api" "etc-api" "eth-api" "neo-api" "xrp-api" "qtum-api" "usdt-api" "xrp-api" "btc-notifier" "etc-notifier" "eth-notifier" "neo-notifier" "xrp-notifier" "qtum-notifier" "usdt-notifier" "xrp-notifier")
for i in ${logs[@]};do
	[ -f $dir/$i/logs/$i.log ] && cp $dir/$i/logs/$i.log $dir/$i/logs/$i.log_$rq &&  echo > $dir/$i/logs/$i.log
done