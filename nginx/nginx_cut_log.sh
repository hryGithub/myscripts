#!/bin/sh

#crontab示例
#0 0 * * * /bin/bash nginx_cut_log.sh
log_dir=/usr/local/nginx/logs
d_dir=$log_dir/`date -d "yesterday" +"%Y%m"`/`date -d "yesterday" +"%d"`
nginx_reload="/usr/local/nginx/sbin/nginx -s reload"

logfiles=`ls $log_dir |grep -e ".log$"`
mkdir -p $d_dir

for i in $logfiles;do
	mv $log_dir/$i $d_dir
done

$nginx_reload