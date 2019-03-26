import os,sys
import subprocess
import re


#定义实时监控模块
def monitor_log(access_log):
    print('monitor access log :%s'%access_log)
    #实时读取访问日志
    popen = subprocess.Popen('tail -f '+access_log,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    
    #进行循环匹配
    while True:
        zz_r = re.compile("\.mdb|\.inc|\.sql|\.config|\.bak|\.svn|info\.php|\.bak|wwwroot|wp-login \
                 |gf_admin|struts|jmx-console|\.ini|\.conf|%2Fpasswd|passwd|\.xml|\.exe|execute|1.asp|admin\.aspx \
                 |dircontext|phpmyadmin|order%20by|%20where%20|%20union%20|%2ctable_name%20|%27exec \
                 |select%20|%20and%201=1|%2csleep|%20and%201=2|div.aps|xiaoma.jsp|tom.jsp|py.jsp \
                 |context\.get|getwriter|information_schema|/k8cmd|ver007.jsp|ver008.jsp|ver007|ver008|%if|\.aar|cmdshell" )
        line=popen.stdout.readline().strip()
        new_line=zz_r.search(line.lower())
        #print("----->",new_line)
        #判断是否有匹配到,如果有匹配则将IP添加到iptables做drop处理
        if new_line:
           #提取恶意IP
           zz = re.compile('[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
           #line_ip = zz.search((line.split(':')[1].split(','))[0]).group()
           line_ip = zz.search(line).group()
           #将IP添加到iptables列表中
           os.system("iptables -I INPUT -s %s -j DROP" %line_ip)
           print('the fuck ip [%s] is added to iptables'%line_ip)


if __name__=='__main__':
    #判断程序启动是否有三个参,如果是三个参则将第三个参数传进monitor_log函数里
    if len(sys.argv) == 3:
        monitor_log(sys.argv[2])
    else:
        msg='''
            input argv is wrong
            example: \033[31;1m python sec_monitor -f access.log\033[0m
            '''
        print(msg)