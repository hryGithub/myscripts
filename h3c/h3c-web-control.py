#!/usr/bin/python
# -*- coding: UTF-8 -*-

import time, smtplib, sys
from selenium import webdriver
from selenium.webdriver.support.ui import Select
from email.mime.text import MIMEText


def h3c_func():
    WEBSITE = 'http://192.168.16.1/userLogin.asp'
    driver = webdriver.Chrome()
    driver.get(WEBSITE)

    # 登陆
    element = driver.find_element_by_xpath("//input[@name='account']")
    element.send_keys("admin")
    element = driver.find_element_by_xpath("//input[@name='password']")
    element.send_keys("abc12345")
    driver.find_element_by_id("longin_button").click()

    # 左侧菜单
    time.sleep(1)   # 等待1s
    fr = driver.find_element_by_xpath("/html/frameset/frameset/frameset/frame")
    driver.switch_to.frame(fr)
    driver.find_element_by_xpath("/html/body/form/table[1]/tbody/tr/td/div/ul/li[4]/a").click()
    time.sleep(1)
    driver.find_element_by_xpath("/html/body/form/table[1]/tbody/tr/td/div/ul/li[4]/ul/li[2]/a").click()

    # 右侧菜单
    driver.switch_to.default_content()
    fr = driver.find_element_by_xpath("/html/frameset/frameset/frameset/frameset/frame[1]")
    driver.switch_to.frame(fr)
    driver.switch_to.frame("main_iframe_0")

    # 填充数据
    s1 = Select(driver.find_element_by_id("search_item"))
    s1.select_by_index(4)
    s2 = Select(driver.find_element_by_id("ap_status"))
    s2.select_by_index(8)
	driver.find_element_by_xpath("//input[@name='txtMaxRows']").clear()
    driver.find_element_by_xpath("//input[@name='txtMaxRows']").send_keys(100)
    driver.find_element_by_xpath("//input[@name='search_start']").click()

    driver.switch_to.frame("ap_online_list_page")
    tds = driver.find_element_by_id("disableclick").find_elements_by_css_selector("tr")
    roomlist = []
    for td in tds:
        s = td.find_elements_by_tag_name("td")[10].text
        if s != "备注":
            roomlist.append(s)
    return roomlist


def send_mail(content):
    smtp_server = 'smtp.exmail.qq.com'
    sslPort = 465
    mail_user = ''
    mail_pass = ''
    msg = MIMEText("以下房间AP离线：\n"+content+"\n请及时重启相应设备！", 'plain', 'utf-8')
    msg['Subject'] = 'AP离线提醒'
    msg['From'] = "AP离线报警平台" + "<" + mail_user + ">"
    msg['to'] = ""

    try:
        # 普通连接
        # s = smtplib.SMTP_SSL(smtp_server)
        s = smtplib.SMTP_SSL(smtp_server, sslPort)
        s.login(mail_user, mail_pass)
        s.sendmail(mail_user, msg['to'], msg.as_string())
        s.close()
        return True
    except Exception as e:
        print(str(e)) 
        return False


if __name__ == "__main__":
    roomlist = h3c_func()
    if len(roomlist) != 0:
        send_mail(','.join(roomlist))