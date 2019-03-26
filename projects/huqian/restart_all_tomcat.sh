#!/bin/bash
set -e

#!/bin/bash

#此脚本用于批量替换tomcat数据源配置文件

src='/opt/app/tomcat'

list=`ls -l "$src"|grep -e '^d'|awk {'print $9'}`

for s in $list;do
    /opt/app/tomcat/restart_tomcat.sh $s
done
