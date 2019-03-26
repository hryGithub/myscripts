#!/bin/bash

#自动扫描并加入黑名单
errlog=/usr/local/nginx/logs/activity_err.log
acclog=/usr/local/nginx/logs/activity_acc.log
tmq_block=/usr/local/nginx/conf/blockips.txt
block_conf=/usr/local/nginx/conf/blockips.conf
nginx_reload='/usr/local/nginx/sbin/nginx -s reload'
tail -n5000 $errlog |awk '{print $14}'|cut -d ',' -f1|grep -E  "([0-9]{1,3}.){3}[0-9]" |sort|uniq -c|sort -rn|awk '{if ($1>50) print "deny "$2";"}' >> $tmq_block
grep "/zapi/mps/send_code" $acclog |awk '{print $1}' |sort|uniq -c|sort -rn|awk '{if ($1>100) print "deny "$2";"}' >> $tmq_block
sort $tmq_block|uniq  >$block_conf

$nginx_reload

