#!/usr/bin/python
# -*- coding: utf-8 -*-

from subprocess import Popen
import redis


r = redis.StrictRedis(host='r-uf6826ll5wbjpz6wbl.redis.rds.aliyuncs.com', port=6379, db=0)

# 获取不到redis种的值,重启爬虫
if not r.get('meituan_save_order17') or not r.get('xiecheng_save_order1') or not r.get('feizhu_save_order32'):
    Popen("c:\\workspace\\restart.bat")
