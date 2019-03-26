#!/bin/sh
#刷新目录
if [ "$1" = "h5-market" ];then
    dir='https://h5.exv.io/h5-market/'
else
    dir='https://static.exv.io/exchange/;https://www.exv.io/'
fi
#用户名
user='ztxxkj'
#purge密码
pass='Tigerft123!'
#接口地址
prefix="http://ccm.chinanetcenter.com/ccm/servlet/contReceiver?"
#生成md5pass
md5sumpass=`printf "${user}${pass}${dir}" | md5sum | awk '{print $1}'`

response=`curl -s "${prefix}username=${user}&passwd=${md5sumpass}&dir=${dir}"`
[ "$response" = "success append purge tasks..." ] && echo 'cdn推送成功!' || echo "cdn推送失败，error_code:$response,请检查!"