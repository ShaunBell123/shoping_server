import redis
import os
import json
from collections import defaultdict

class RedisCache:

    def __init__(self):
        self.redis = redis.Redis(
            host=os.getenv('REDIS_HOST'),
            port=int(os.getenv('REDIS_PORT')),
            ssl=os.getenv('REDIS_SSL', 'False') == 'True',
            decode_responses=True
        )

    def check_cache(self, shops_list):
        cached_grouped = defaultdict(list)
        missing_grouped = defaultdict(list)

        entries = []
        keys = []
        for shop in shops_list:
            for product in shop.products:
                key = f"{shop.shop_name}:{product.name}"
                keys.append(key)
                entries.append((shop, product))

        values = self.redis.mget(keys)

        for (shop, product), value in zip(entries, values):
            if value is None:
                missing_grouped[shop.shop_name].append({
                    "requested": product.name,
                    "product": None
                })
            else:
                cached_grouped[shop.shop_name].append({
                    "requested": product.name,
                    "product": json.loads(value)
                })

        return cached_grouped, missing_grouped

    def cache_data(self, data: dict):

        for shop_name, products in data.items():
            for product_data in products:
                requested = product_data["requested"]
                product_info = product_data["product"]

                key = f"{shop_name}:{requested}"
                self.redis.set(key, json.dumps(product_info))
