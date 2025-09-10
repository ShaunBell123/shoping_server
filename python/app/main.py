from fastapi import FastAPI
from .scraper import Scraper
from pydantic import BaseModel
from .tesco_scraper import TescoScraper

app = FastAPI()

scraper_map = {
    cls.__name__.replace("Scraper", "").lower(): cls
    for cls in Scraper.__subclasses__()
}

class Item(BaseModel):
    shop_name: str
    shoping_list: list

@app.post("/process")
async def process(item: Item):

    scraper_type = item.shop_name.strip().lower()
    scraper_class = scraper_map.get(scraper_type)
    
    if not scraper_class:
        return {"error": f"Unknown scraper type: {scraper_type}"}

    if not item.shoping_list:
        return {"error": "Shopping list cannot be empty"}

    scraper = scraper_class(site_name=item.shop_name, shoping_list=item.shoping_list)
    result = scraper.scrape()

    return {"result": result}