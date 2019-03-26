#!/bin/bash 

src='/usr/local/nginx/conf/upstream'
app_env_file='app_env_file.txt'
#app_env_file.txt示例
#app 192.168.9.100:1002
apps=`cat $app_env_file|awk '{print $1}'|sort |uniq`

for app in ${apps[@]};do
    ip_ports=`grep -e "^$app\s" $app_env_file | awk '{print $2}'|sort|uniq`
    [ ! -f $src/$app.conf ] && touch $src/$app.conf
    echo -e "upstream $app {" > $src/$app.conf
    for ip_port in ${ip_ports[@]};do
        echo -e "\tserver $ip_port max_fails=3 fail_timeout=2;" >> $src/$app.conf
    done
    echo -e "}" >> $src/$app.conf
done


