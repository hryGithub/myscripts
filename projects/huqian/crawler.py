#!/usr/bin/python
# -*- coding: UTF-8 -*-
import json
import urllib3
import time
import pymysql
from bs4 import BeautifulSoup

user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.101 Safari/537.36'


def insert_sql_db(currency_type, currency_direction, select_time,
                  currency_price, datasources):
    db = pymysql.connect(
        "192.168.9.148", "counteruser", "counteruser", "counter", charset='utf8')
    cursor = db.cursor()
    sql = """INSERT INTO t_trade_price(curr_base,
         curr_trade, trade_direction, select_time, period_current, data_from, is_delete)
         VALUES ('USDT', %r, %s, %r, %s, %r,1)""" % (currency_type,
                                                     currency_direction,
                                                     select_time,
                                                     currency_price,
                                                     datasources)
    # print(sql)
    try:
        cursor.execute(sql)
        db.commit()
    except:
        db.rollback()
    db.close()


def huobi_get_price(currency, type, cointype, **args):
    currency_dict = {"cny": 1, "hkd": 13}
    currencyId = currency_dict[currency]
    coinId = 2
    url = "https://otc-api.hbg.com/v1/data/trade-market?country=0&currency=%s&payMethod=0&currPage=1&coinId=%s&tradeType=%s&blockType=general&online=1" % (
        currencyId, coinId, type)
    if args:
        http = urllib3.ProxyManager(args['proxy'])
    else:
        http = urllib3.PoolManager()
    urllib3.disable_warnings()
    rs = http.request('GET', url, headers={'User-Agent': user_agent})
    rsjson = json.loads(rs.data.decode("utf8"))
    return rsjson['data'][0]['price']


def okex_get_price(transfer_type, **args):
    url = "https://www.okex.com/v3/c2c/tradingOrders/book?side=%s&baseCurrency=usdt&quoteCurrency=cny&userType=certified&paymentMethod=all" % (
        transfer_type)
    if args:
        http = urllib3.ProxyManager(args['proxy'])
    else:
        http = urllib3.PoolManager()
    urllib3.disable_warnings()
    rs = http.request('GET', url, headers={'User-Agent': user_agent})
    rsjson = json.loads(rs.data.decode("utf8"))
    return rsjson['data'][transfer_type][0]['price']


def kraken_get_price(transfer_type, **args):
    url = "https://api.kraken.com/0/public/Trades?pair=USDTZUSD"
    if args:
        http = urllib3.ProxyManager(args['proxy'])
    else:
        http = urllib3.PoolManager()
    urllib3.disable_warnings()
    rs = http.request('GET', url, headers={'User-Agent': user_agent})
    rsjson = json.loads(rs.data.decode("utf8"))
    for i in rsjson['result']['USDTZUSD']:
        # print i
        if i[3] == transfer_type:
            # print " %s %s"%(transfer_type, i)
            return i[0]


def otcbtc_get_price(currency, type, conitype, **args):
    url = "https://otcbtc.com/%s_offers?currency=%s&fiat_currency=%s&payment_type=all" % (
        type, conitype, currency)
    if args:
        http = urllib3.ProxyManager(args['proxy'])
    else:
        http = urllib3.PoolManager()
    urllib3.disable_warnings()
    r = http.request('GET', url)
    soup = BeautifulSoup(r.data.decode("utf-8"), "html")
    # print(soup.find(class_="price"))
    try:
        return float(soup.find(class_="price").text.split("\n")[2])
    except:
        return None


if __name__ == "__main__":
    crawler_time = time.strftime('%Y.%m.%d %H:%M:00',
                                 time.localtime(time.time()))
    currency_direction_buy = 0
    currency_direction_sell = 1
    # huobi
    # insert_sql_db(currency_type, currency_direction, select_time, currency_price, datasources)
    insert_sql_db("cny", currency_direction_buy, crawler_time,
                  huobi_get_price(
                      "cny", "buy", "usdt",
                      proxy="http://192.168.9.163:28118"), "huobi")
    insert_sql_db("cny", currency_direction_sell, crawler_time,
                  huobi_get_price(
                      "cny",
                      "sell",
                      "usdt",
                      proxy="http://192.168.9.163:28118"), "huobi")
    insert_sql_db("hkd", currency_direction_buy, crawler_time,
                  huobi_get_price(
                      "hkd", "buy", "usdt",
                      proxy="http://192.168.9.163:28118"), "huobi")
    insert_sql_db("hkd", currency_direction_sell, crawler_time,
                  huobi_get_price(
                      "hkd",
                      "sell",
                      "usdt",
                      proxy="http://192.168.9.163:28118"), "huobi")

    # ok
    insert_sql_db("cny", currency_direction_buy, crawler_time,
                  okex_get_price("buy", proxy="http://192.168.9.163:28118"),
                  "okex")
    insert_sql_db("cny", currency_direction_sell, crawler_time,
                  okex_get_price("sell", proxy="http://192.168.9.163:28118"),
                  "okex")

    # kraken
    insert_sql_db("usd", currency_direction_buy, crawler_time,
                  kraken_get_price("b", proxy="http://192.168.9.163:28118"),
                  "kraken")
    insert_sql_db("usd", currency_direction_sell, crawler_time,
                  kraken_get_price("s", proxy="http://192.168.9.163:28118"),
                  "kraken")

    # otcbtc
    insert_sql_db("cny", currency_direction_buy, crawler_time,
                  otcbtc_get_price(
                      "cny", "buy", "usdt",
                      proxy="http://192.168.9.163:28118"), "otcbtc")
    insert_sql_db("cny", currency_direction_sell, crawler_time,
                  otcbtc_get_price(
                      "cny",
                      "sell",
                      "usdt",
                      proxy="http://192.168.9.163:28118"), "otcbtc")
    insert_sql_db("hkd", currency_direction_buy, crawler_time,
                  otcbtc_get_price(
                      "hkd", "buy", "usdt",
                      proxy="http://192.168.9.163:28118"), "otcbtc")
    insert_sql_db("hkd", currency_direction_sell, crawler_time,
                  otcbtc_get_price(
                      "hkd",
                      "sell",
                      "usdt",
                      proxy="http://192.168.9.163:28118"), "otcbtc")
