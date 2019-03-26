#!/usr/bin/env python
# coding:utf8
import sys

import paramiko

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


# 远程执行命令
def sshclient_execmd(hostname, port, username, password, command):
    paramiko.util.log_to_file("paramiko.log")
    s = paramiko.SSHClient()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    s.connect(
        hostname=hostname, port=port, username=username, password=password)
    stdin, stdout, stderr = s.exec_command(command)
    stdin.write(
        "Y"
    )  # Generally speaking, the first connection, need a simple interaction.
    print(stdout.read())
    s.close()


# 获取应用所在服务器
def app_get_host(apps, appname):
    return [k for k, v in apps.items() if appname in v]


# 重启应用
def restart_app(app):
    username = 'root'
    password = 'tigerft123'
    port = 22
    command = '/opt/app/tomcat/restart_tomcat.sh %s' % app
    hosts = app_get_host(apps, app)
    if len(hosts):
        for ip in hosts:
            print("开始重启%s服务器上的%s应用，请稍后..." % (ip, app))
            sshclient_execmd(ip, port, username, password, command)
            print("%s服务器上的%s应用重启完成！" % (ip, app))
    else:
        print("找不到应用所在的服务器，请联系管理员！")
        exit(1)


if __name__ == "__main__":
    restart_app(sys.argv[1])
