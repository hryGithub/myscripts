#!/bin/bash
#本脚本用于监测后台服务，非200报警

#报警收件人
to="hujian@tigerft.com,yangwz@tigerft.com,zhangyj@tigerft.com"
#linux默认编码utf8，转码以后解决fxmail等客户端主题乱码问题
subject=`echo -n "交易所服务访问异常提醒" |iconv -t GB2312 -f utf-8`
#subject=`echo -n "钱包服务访问异常提醒" |iconv -t GB2312 -f utf-8`
base_url="http://soa.tigerfin.com"
#需要监测的java应用
apps=(
    "privilege-api"
    "uni-audit"
    "uni-auth"
    "uni-login"
    "ues-ws"
    "ues-console"
    "ufs"
    "counter-api"
    "mns-web"
    "smsgateway-ws"
    "pbs"
    "pbs-bos"
    "voucher"
    "acs"
    "fos"
    "tss"
    "payment"
    "payment-carryover"
    "pfs-basis"
    "pfs-manager"
    "pfs-payment"
    "fcw"
    "bank-btc"
    "bank-eth"
    "bank-usdt"
    "bank-qtum"
    "bank-aac"
    "bank-omg"
    "bank-snt"
    "bank-storm"
    "bank-icx"
    "bank-ven"
    "bank-dgd"
    "bank-abt"
    "bank-ocn"
    "bank-ncash"
    "bank-erc"
    "cmf"
    "notifychannel"
    "dpm-accounting"
    "dpm-manager"
    "tmq"
    "ma-web"
    "rms-cep"
    "rms-rules"
)

monitor()
{
    for app in ${apps[@]};do
        code=$(curl -s -o /dev/null -m 10 --connect-timeout 10 $base_url/$app/_heath_check -w %{http_code})
        if [ $code != 200 ];then
            body="$app访问不成功，状态码$code,请及时修复！" 
            #echo "$base_url/$app/_heath_check      $code" >> 1.txt
            #sendmail $to $subject $body

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