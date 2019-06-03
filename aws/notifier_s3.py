#!/usr/bin/python
# -*- coding: utf-8 -*-
# 定时器触发
# 0 4 * * * python /data/scripts/notifier_s3.py >> /root/notifer_s3.log 2>&1
import boto3
import os
import subprocess
import datetime

bucketName = ''
accessKey = ''
secretKey = ''


def upload_file(oss_dir, f):
    filename = os.path.basename(f)
    ObjectName = oss_dir.strip("/") + "/" + filename
    s3 = boto3.client('s3', aws_access_key_id=accessKey, aws_secret_access_key=secretKey)
    s3.upload_file(f, bucketName, ObjectName)
    print(f + "成功上传到:" + ObjectName)


if __name__ == '__main__':
    # 获取最近的文件，拼接路径上传
    print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    sub = subprocess.Popen("find /bankGlide/ -mtime 0 -type f", shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    rs = sub.stdout.read().split("\n")
    for f in rs:
        if os.path.isfile(f):
            oss_dir = '/counter' + os.path.dirname(f)
            upload_file(oss_dir, f)