#!/usr/bin/env python
# coding:utf8
import sys
import paramiko
import apps


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


# 重启应用
def restart_app(app):
    username = 'root'
    password = 'tigerft123'
    port = 22
    command = '/opt/app/tomcat/restart_tomcat.sh %s' % app
    hosts = apps.app_get_host(app).split(' ')
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
