#!/usr/bin/env python
# coding:utf8
import sys

# 服务器上应用分布
apps = {
    "192.168.9.161":
    "privilege-admin,privilege-api,uni-audit,uni-auth,uni-login,ues-ws, \
    ues-console,ufs,counter,counter-api,basis,ufs-admin,oss-web,mns-admin, \
    mns-web,mns-mq-listener,mns-scheduler-web,smsgateway-ws,sqlmonitor",
    "192.168.9.162":
    "pbs,pbs-bos,voucher,acs,fos,tss,payment,payment-carryover, \
    payment-task,pfs-basis,pfs-manager,pfs-payment,fcw,bank-btc, \
    bank-eth,bank-usdt,bank-qtum,bank-qtum,bank-aac,bank-omg,bank-snt",
    "192.168.9.163":
    "cmf,cmf-task,cmf,cmf-task,notifychannel, \
    dpm-task,dpm-accounting,dpm-manager,auz-task,tmq,tmq-task,exc,ma-web,cert",
    "192.168.9.164":
    "fag,wag,mps,exvactivity,market,rms-cep,rms-intra,rms-monitor,rms-rules,cag",
    "192.168.9.167":
    "bank-abt,bank-dgd,bank-erc,bank-icx,bank-ncash,bank-ocn,bank-storm,bank-ven,otcg"
}



# 获取应用所在服务器

def app_get_host(appname):
    hosts = [k for k, v in apps.items() if appname in v]
    return ' '.join(hosts)


if __name__ == "__main__":
    print(app_get_host(sys.argv[1]))