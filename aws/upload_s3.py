#!/usr/bin/python
# -*- coding: utf-8 -*-

import boto3
import os
import sys

bucketName = ''
accessKey = ''
secretKey = ''


def upload_file(oss_dir, f):
    filename = os.path.basename(f)
    ObjectName = oss_dir.strip("/") + "/" + filename
    s3 = boto3.client('s3', aws_access_key_id=accessKey, aws_secret_access_key=secretKey)
    s3.upload_file(f, bucketName, ObjectName)
    print(f + "成功上传到:" + ObjectName)


def list_dir(basedir, path):
    lst = os.listdir(path)
    for f in lst:
        temp_path = os.path.join(path, f)
        if os.path.isfile(temp_path):
            #print(temp_path)
            #print(os.path.dirname(temp_path).replace(basedir,"/"))
	        upload_file(os.path.dirname(temp_path).replace(basedir,"/"), temp_path)
        else:
            list_dir(basedir, temp_path)


if __name__ == '__main__':
    list_dir('/opt/ufs/base/', '/opt/ufs/base/')