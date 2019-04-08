#!/usr/bin/python
# -*- coding: UTF-8 -*-
import oss2
import sys

EndPoint = 'http://oss-cn-hongkong.aliyuncs.com'
AccessKeyId = ''
AccessKeySecret = ''
BucketName = 'viausdfile'


def upload_file(type, file):
    ObjectName = '/app/' + type + '/' + file
    print(ObjectName)
    # auth = oss2.Auth(AccessKeyId, AccessKeySecret)
    # bucket = oss2.Bucket(auth, EndPoint, BucketName)
    # bucket.put_object_from_file(ObjectName, file)


if __name__ == "__main__":
    upload_file(sys.argv[1], sys.argv[2])
    