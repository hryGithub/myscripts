#!/usr/bin/python
# -*- coding:utf-8 -*-

import sys,os
import urllib.parse
import base64
import hmac
import hashlib
from hashlib import sha1
import time
import uuid
import json


def percent_encode(str):
    res = urllib.parse.quote(str, '')
    res = res.replace('+', '%20')
    res = res.replace('*', '%2A')
    res = res.replace('%7E', '~')
    return res


def compute_signature(parameters, access_key_secret):
    sortedParameters = sorted(parameters.items(), key=lambda parameters: parameters[0])

    canonicalizedQueryString = ''
    for (k, v) in sortedParameters:
        canonicalizedQueryString += '&' + percent_encode(k) + '=' + percent_encode(v)

    stringToSign = 'GET&%2F&' + percent_encode(canonicalizedQueryString[1:])

    h = hmac.new(b'{access_key_secret + "&"}', b'{stringToSign}', sha1)
    signature = base64.encodestring(h.digest()).strip()
    return signature


def compose_url(user_params):
    timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

    parameters = { \
            'Format'        : 'JSON', \
            'Version'       : '2014-11-11', \
            'AccessKeyId'   : access_key_id, \
            'SignatureVersion'  : '1.0', \
            'SignatureMethod'   : 'HMAC-SHA1', \
            'SignatureNonce'    : str(uuid.uuid1()), \
            'TimeStamp'         : timestamp, \
    }

    for key in user_params.keys():
        parameters[key] = user_params[key]

    signature = compute_signature(parameters, access_key_secret)
    parameters['Signature'] = signature
    url = cdn_server_address + "/?" + urllib.parse.urlencode(parameters)
    return url


def make_request(user_params, quiet=False):
    url = compose_url(user_params)
    print(url)
    # try:
    #     req = urllib2.Request(url)
    #     res_data = urllib2.urlopen(req)
    #     res = res_data.read()
    #     return res
    # except:
    #     return user_params['ObjectPath'] + ' refresh failed!'

if __name__ == "__main__":
    cdn_server_address = 'http://cdn.aliyun.com'
    access_key_id = 'id'
    access_key_secret = 'secret'
    objectpath = sys.argv[1]
    user_params = {'Action': 'RefreshObjectCaches', 'ObjectPath': objectpath, 'ObjectType': 'File'}
    make_request(user_params)