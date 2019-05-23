#!/usr/bin/python
# -*- coding: UTF-8 -*-
import oss2
import sys
import os


EndPoint = 'oss-cn-hongkong.aliyuncs.com'
AccessKeyId = ''
AccessKeySecret = ''
BucketName = 'viausdfile'


def upload_file(oss_dir, f):
    filename = os.path.basename(f)
    ObjectName = oss_dir.strip("/") + "/" + filename
    #print(filename)
    auth = oss2.Auth(AccessKeyId, AccessKeySecret)
    bucket = oss2.Bucket(auth, EndPoint, BucketName)
    bucket.put_object_from_file(ObjectName, f)
    print("文件下载地址为:%s" % "https://" + BucketName + "." + EndPoint + oss_dir + filename)


if __name__ == "__main__":
    upload_file(sys.argv[1], sys.argv[2])