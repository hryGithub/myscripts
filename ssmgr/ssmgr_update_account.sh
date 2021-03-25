#!/bin/bash
#定时清空流量
#0 0 1 * * /bin/bash ssmgr_update_account.sh
tables=(saveFlow saveFlow5min saveFlowHour saveFlowDay)
for t in ${tables[@]};do
update_sql="update $t set accountId=0;"

sqllitedb="sqlite3 /root/.ssmgr/webgui.sqlite"
$sqllitedb <<EOF
$update_sql
.quit
EOF

done