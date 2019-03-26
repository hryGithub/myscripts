#!/bin/bash

#判断操作系统版本

if cat /proc/version |grep -q 'Red Hat';then
    HOST=`ifconfig |grep inet |grep -vE '127.0.0.1|inet6' |awk '{print $2}'`
elif cat /proc/version |grep -q 'Ubuntu';then
    HOST=`ifconfig |grep inet |grep -vE '127.0.0.1|inet6' |awk '{print $2}'|cut -d ':' -f2`
else
    echo "目前只支持redhat,centos及ubuntu"
    exit 1
fi
#初始化
cmd='/usr/local/ttserver/tokyotyrant-1.1.41/bin/tcrmgr'
$cmd put -port 1978 "$HOST" index.com.netfinworks.cache.cc "$HOST":30001
$cmd put -port 1978 "$HOST" index.com.netfinworks.ma.cache "$HOST":30002
$cmd put -port 1978 "$HOST" index.com.netfinworks.dpm "$HOST":30003
$cmd put -port 1978 "$HOST" index.com.netfinworks.cmf.fundChannel "$HOST":30004
$cmd put -port 1978 "$HOST" index.com.netfinworks.cmf.unityCode "$HOST":30005
$cmd put -port 1978 "$HOST" index.com.netfinworks.rms.rules "$HOST":30006
$cmd put -port 1978 "$HOST" index.com.netfinworks.lflt "$HOST":30007
$cmd put -port 1978 "$HOST" index.com.netfinworks.guardian.login "$HOST":30008
$cmd put -port 1978 "$HOST" index.com.netfinworks.guardian.roles "$HOST":30009
$cmd put -port 1978 "$HOST" index.com.netfinworks.pfs.payment "$HOST":30010
$cmd put -port 1978 "$HOST" index.com.netfinworks.pfs.basis "$HOST":30011
$cmd put -port 1978 "$HOST" index.com.netfinworks.site.cache "$HOST":30012
$cmd put -port 1978 "$HOST" index.com.netfinworks.cashier.service "$HOST":30013
$cmd put -port 1978 "$HOST" index.com.netfinworks.deposit.service "$HOST":30014
$cmd put -port 1978 "$HOST" index.com.netfinworks.enterprisesite.cache "$HOST":30015
$cmd put -port 1978 "$HOST" index.com.netfinworks.captcha "$HOST":30016
$cmd put -port 1978 "$HOST" index.com.netfinworks.ma.authorize "$HOST":30017
$cmd put -port 1978 "$HOST" index.com.netfinworks.site.login "$HOST":30018
$cmd put -port 1978 "$HOST" index.com.netfinworks.ffs "$HOST":30019
$cmd put -port 1978 "$HOST" index.com.netfinworks.counter "$HOST":30020
$cmd put -port 1978 "$HOST" index.com.netfinworks.common "$HOST":30021
$cmd put -port 1978 "$HOST" index.com.netfinworks.cmf.channelintegration "$HOST":30022
$cmd put -port 1978 "$HOST" index.com.netfinworks.locker.abs "$HOST":30023
$cmd put -port 1978 "$HOST" index.com.tigerft.tmq "$HOST":30024
$cmd put -port 1978 "$HOST" index.com.tigerft.exchange.auto.auz "$HOST":30025
$cmd put -port 1978 "$HOST" index.com.netfinworks.locker.csa "$HOST":30026
$cmd put -port 1978 "$HOST" index.com.tigerft.exchange.auz "$HOST":30027   
    