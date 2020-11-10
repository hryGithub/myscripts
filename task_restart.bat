@echo off

rem 获取爬虫进程并关闭
for /f "tokens=2" %%a in ('tasklist ^|findstr java') do (taskkill /F /pid %%a)

rem 重启服务器
start  /D "C:\workspace\" meituan.bat

timeout /nobreak /t 30
start  /D "C:\workspace\" xiecheng.bat

timeout /nobreak /t 30
start  /D "C:\workspace\" feizhu.bat

pause
exit
