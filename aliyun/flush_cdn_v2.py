#!/usr/bin/python
# -*- coding:utf-8 -*-

import sys
from aliyunsdkcore.client import AcsClient
from aliyunsdkcdn.request.v20180510 import RefreshObjectCachesRequest


#用户身份验证参数配置
ACS_CLIENT = AcsClient(
    'your-access-key-id',     #your-access-key-id
    'your-access-key-secret',   #your-access-key-secret
    'your-region-id',     #your-region-id
)


def flush_cdn_directory(path):
    request = RefreshObjectCachesRequest.RefreshObjectCachesRequest()
    request.set_ObjectPath(path)
    request.set_ObjectType('Directory')
    print(ACS_CLIENT.do_action_with_exception(request))

if __name__ == "__main__":
    flush_cdn_directory(sys.argv[1])


