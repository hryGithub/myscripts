#!/bin/bash


#crontab示例
#0 0 * * * /bin/bash cut_log.sh

# rq=`date -d "yesterday" +%Y%m%d`
rq=`date +%Y%m%d-%H`
backupcmd=/usr/bin/mongodump
dbhost=127.0.0.1
port=27017
user=
passwd=

#
tmp_bak_dir=/data/mongobak/temp
bak_dir=/data/mongobak

#保留时间
expir_days=7


[ ! -d $tmp_bak_dir ] && mkdir $tmp_bak_dir -p 
[ ! -d $bak_dir ] && mkdir $bak_dir -p

rm -rf $tmp_bak_dir/*
#备份
#$backupcmd -h $dbhost:$port -u $user -p $passwd  -o $tmp_bak_dir
$backupcmd -h $dbhost:$port -o $tmp_bak_dir
#压缩
cd $tmp_bak_dir && tar zcf mongobak-$rq.tar.gz * && mv mongobak-$rq.tar.gz $bak_dir
#删除过期备份
find $bak_dir/ -mtime +$expir_days -delete