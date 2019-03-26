#!/bin/bash
#定时更新用户的有效期
#0 0 1 * 0 /bin/bash ssmgr_update_account.sh
ts=`date +%s`000
update_sql="update account_plugin set data='{"create":$ts,"flow":5000000000,"limit":1}';"

sqllitedb="sqlite3 /root/.ssmgr/webgui.sqlite"

$sqllitedb <<EOF
$update_sql
.quit
EOF