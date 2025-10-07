from fastapi import FastAPI
from .cashe.redis_cache import RedisCache
from .scrap.scraper import Scraper
from pydantic import BaseModel
from concurrent.futures import ThreadPoolExecutor
from typing import List, Optional
from typing import List, Dict, Any

from .scrap.tesco_scraper import TescoScraper
from .scrap.asda_scraper import AsdaScraper

app = FastAPI()

scraper_map = { cls.__name__.replace("Scraper", "").lower(): cls for cls in Scraper.__subclasses__() }

class Product(BaseModel):
    name: str

class Shop(BaseModel):
    shop_name: str
    products: List[Product]

class ScrapeConfig(BaseModel):
    shops: List[Shop]

def scrape_shop(shop_name: str, products: list) -> Dict[str, Any]:

    scraper_type = shop_name.lower()
    scraper_class = scraper_map.get(scraper_type)

    scraper = scraper_class(scraper_type, products)
    results = scraper.scrape()

    return results

@app.post("/process")
async def process(config: ScrapeConfig):
    shops = config.shops

    cache = RedisCache()
    cached, missing = cache.check_cache(shops)

    # cached: dict[str, list[dict]]  e.g., "tesco" -> [product dicts]
    # missing: dict[str, list[str]]   e.g., "tesco" -> ["milk", "bread"]

    final = dict(cached)

    if missing:

        with ThreadPoolExecutor(max_workers=len(missing)) as executor:
            results = list(executor.map(
                lambda item: scrape_shop(item[0], item[1]),
                missing.items() 
            ))

            for shop_data in results:
                for shop_name, products in shop_data.items():
                    final.setdefault(shop_name, []).extend(products)

            for shop_data in results:
                print(f"Scraped data: {shop_data}")
                cache.cache_data(shop_data)

    return final
