#!/bin/bash
#本脚本用于监测后台服务，非200报警

#报警收件人
to="hujian@tigerft.com,yangwz@tigerft.com,zhangyj@tigerft.com"
subject=`echo -n "交易所服务访问异常提醒" |iconv -t GB2312 -f utf-8`
#需要监测的url
urls=(
    "http://soa.tigerfin.com/fag/"
    "http://soa.tigerfin.com/wag/"
    "http://soa.tigerfin.com/privilege-api/"
    "http://soa.tigerfin.com/uni-audit/"
    "http://soa.tigerfin.com/uni-auth/"
    "http://soa.tigerfin.com/ues-ws/service"
    "http://soa.tigerfin.com/ufs/"
    "http://soa.tigerfin.com/counter-api/"
    "http://soa.tigerfin.com/mns-web/_health_check"
    "http://soa.tigerfin.com/smsgateway-ws/service"
    "http://soa.tigerfin.com/pbs/cxf-service/"
    "http://soa.tigerfin.com/pbs-bos/cxf-service/"
    "http://soa.tigerfin.com/voucher"
    "http://soa.tigerfin.com/acs"
    "http://soa.tigerfin.com/fos/service/"
    "http://soa.tigerfin.com/tss"
    "http://soa.tigerfin.com/payment/services"
    "http://soa.tigerfin.com/payment-carryover/services"
    "http://soa.tigerfin.com/pfs-basis/service"
    "http://soa.tigerfin.com/pfs-manager/service"
    "http://soa.tigerfin.com/pfs-payment/service"
    "http://soa.tigerfin.com/fcw/server/CMB10101-VS.htm"
    "http://soa.tigerfin.com/bank-btc/services"
    "http://soa.tigerfin.com/bank-eth/services"
    "http://soa.tigerfin.com/bank-usdt/services"
    "http://soa.tigerfin.com/bank-qtum/services"
    "http://soa.tigerfin.com/bank-aac/services"
    "http://soa.tigerfin.com/bank-omg/services"
    "http://soa.tigerfin.com/bank-snt/services"
    "http://soa.tigerfin.com/bank-storm/services"
    "http://soa.tigerfin.com/bank-icx/services"
    "http://soa.tigerfin.com/bank-ven/services"
    "http://soa.tigerfin.com/bank-dgd/services"
    "http://soa.tigerfin.com/bank-abt/services"
    "http://soa.tigerfin.com/bank-ocn/services"
    "http://soa.tigerfin.com/bank-ncash/services"
    "http://soa.tigerfin.com/bank-erc/services"
    "http://soa.tigerfin.com/cmf/services"
    "http://soa.tigerfin.com/notifychannel/services"
    "http://soa.tigerfin.com/dpm-accounting/services"
    "http://soa.tigerfin.com/dpm-manager"
    "http://soa.tigerfin.com/tmq/service"
    "http://soa.tigerfin.com/ma-web"
    "http://soa.tigerfin.com/rms-cep/service"
    "http://soa.tigerfin.com/rms-rules/service/"
)

monitor()
{
    for url in ${urls[@]};do
        code=$(curl -i -s -o /dev/null -m 10 --connect-timeout 10 -w %{http_code} $url)
        #code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $url)
        if [ $code != 200 ];then
            body="$url访问不成功，状态码$code,请及时修复！" 
            #sendmail $to $subject $body
            echo $body
            echo $url >> error
        fi
	sleep 1
    done
}

sendmail()
{
    to=$1
    subject=$2
    body=$3
    sender=sysinfo_local@tigerft.com
    smtp_server=smtp.exmail.qq.com
    user=sysinfo_local@tigerft.com
    password=BPg2dXrN
    logfile=/var/log/monitor-mail.log
    /usr/local/bin/sendEmail -o message-content-type=html -o message-charset=utf8 -o tls=no -f $sender -t "$to" -s $smtp_server  -xu $user -xp $password  -u "$subject" -m "$body" -l $logfile
}

monitor
