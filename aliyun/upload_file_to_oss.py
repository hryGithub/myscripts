#!/usr/bin/python
# -*- coding: UTF-8 -*-
import oss2
import sys
import os


EndPoint = 'http://oss-cn-hongkong.aliyuncs.com'
AccessKeyId = ''
AccessKeySecret = ''
BucketName = 'viausdfile'


def upload_file(f):
    filename = os.path.basename(f)
    ObjectName = 'app/android/' + filename
    print(filename)
    auth = oss2.Auth(AccessKeyId, AccessKeySecret)
    bucket = oss2.Bucket(auth, EndPoint, BucketName)
    bucket.put_object_from_file(ObjectName, f)


if __name__ == "__main__":
    upload_file(sys.argv[1])
    