@echo off

rem 根据进程名称获取pid并关闭
for /f "tokens=2" %%a in ('tasklist ^|findstr java') do (taskkill /F /pid %%a)



rem 重启应用
start  /D "C:\workspace\" meituan.bat
start  /D "C:\workspace\" xiecheng.bat

pause
exit