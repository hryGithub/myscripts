#!/usr/bin/python
# -*- coding: UTF-8 -*-
import oss2
import sys
import os


EndPoint = 'oss-cn-shanghai.aliyuncs.com'
AccessKeyId = ''
AccessKeySecret = ''
BucketName = ''


def upload_file(oss_dir, f):
    filename = os.path.basename(f)
    ObjectName = oss_dir.strip("/") + "/" + filename
    auth = oss2.Auth(AccessKeyId, AccessKeySecret)
    bucket = oss2.Bucket(auth, EndPoint, BucketName)
    bucket.put_object_from_file(ObjectName, f)

    # 设置文件访问权限公共读
    bucket.put_object_acl(ObjectName, oss2.OBJECT_ACL_PUBLIC_READ)

    # 软链(软链不能以/开头)
    bucket.put_symlink(ObjectName, 'apkdownload/innowealth-release.apk')

    # 软链权限
    bucket.put_object_acl('apkdownload/innowealth-release.apk', oss2.OBJECT_ACL_PUBLIC_READ)

    print("文件下载地址为:%s" % "https://" + BucketName + "." + EndPoint + ObjectName)
    


if __name__ == "__main__":
    upload_file(sys.argv[1], sys.argv[2])