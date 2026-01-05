import requests
import pandas as pd
from pymongo import MongoClient
from pymongo.errors import PyMongoError

def get_starbucks_data(city, keywords, api_key):
    """调用高德POI API获取指定城市的星巴克数据"""
    url = "https://restapi.amap.com/v3/place/text"
    page = 1
    offset = 20
    all_data = []

    while True:
        params = {
            "key": api_key,
            "keywords": keywords,
            "city": city,
            "citylimit": True,  # 限制仅搜索指定城市
            "offset": offset,
            "page": page,
            "output": "json"
        }

        try:
            response = requests.get(url, params=params)
            response.raise_for_status()  # 捕获HTTP请求错误
            result = response.json()

            if result.get("status") != "1":
                print(f"API请求失败：{result.get('info')}")
                break

            pois = result.get("pois", [])
            if not pois:  # 无数据则终止循环
                break

            # 提取门店核心信息
            for poi in pois:
                location = poi.get("location", "")
                lng, lat = (location.split(",") if location else ("", ""))
                store_data = {
                    "门店名称": poi.get("name", ""),
                    "详细地址": poi.get("address", ""),
                    "联系电话": poi.get("tel", "无"),
                    "经度": lng,
                    "纬度": lat,
                    "所在区域": poi.get("adname", ""),
                    "门店类型": poi.get("type", "")
                }
                all_data.append(store_data)

            print(f"已获取第{page}页，共{len(pois)}条数据")
            page += 1

        except requests.exceptions.RequestException as e:
            print(f"网络异常：{e}")
            break

    return all_data

def connect_mongodb():
    """连接MongoDB，返回数据库对象和集合对象"""
    try:
        # 连接本地MongoDB（默认端口27017，无认证）
        # 若MongoDB有账号密码，修改为：MongoClient("mongodb://用户名:密码@localhost:27017/")
        client = MongoClient("mongodb://localhost:27017/")
        
        # 创建/使用数据库：StarbucksDB
        db = client["StarbucksDB"]
        
        # 创建/使用集合：WuhanStarbucks（类似SQL的表）
        collection = db["WuhanStarbucks"]
        
        print("MongoDB连接成功！")
        return db, collection
    except PyMongoError as e:
        print(f"MongoDB连接失败：{e}")
        return None, None

def insert_data_to_mongodb(collection, data_list):
    """将数据插入MongoDB集合"""
    if not data_list:
        print("无数据可插入")
        return

    try:
        # 批量插入数据（效率高于逐条插入）
        collection.insert_many(data_list)
        print(f"成功插入{len(data_list)}条数据到MongoDB！")
    except PyMongoError as e:
        print(f"插入数据失败：{e}")

if __name__ == "__main__":
    # -------------------------- 需修改的配置 --------------------------
    API_KEY = "e656084ccaa4e91d1d234ddeb82cf320"  # 替换为你在高德平台获取的Key
    # -----------------------------------------------------------------
    CITY = "武汉"
    KEYWORDS = "星巴克"

    # 1. 爬取数据
    print(f"开始爬取{CITY}{KEYWORDS}数据...")
    starbucks_data = get_starbucks_data(CITY, KEYWORDS, API_KEY)

    # 2. 存储到MongoDB
    if starbucks_data:
        db, collection = connect_mongodb()
        if db and collection:
            # 可选：清空集合原有数据（避免重复存储，根据需求选择）
            # collection.delete_many({})
            insert_data_to_mongodb(collection, starbucks_data)
            # 关闭MongoDB连接（可选，pymongo会自动管理连接池）
            # client.close()
    else:
        print("未爬取到任何数据")