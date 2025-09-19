from fastapi import FastAPI
from .scraper import Scraper
from pydantic import BaseModel

app = FastAPI()

# this will automatically import all scraper subclasses
from .tesco_scraper import TescoScraper
from .asda_scraper import AsdaScraper

scraper_map = {
    cls.__name__.replace("Scraper", "").lower(): cls
    for cls in Scraper.__subclasses__()
}

class Item(BaseModel):
    shop_name: list
    shoping_list: list

@app.post("/process")
async def process(item: Item):

    if not item.shoping_list:
        return {"error": "Shopping list cannot be empty"}
    
    result = []

    for shop in item.shop_name:
        scraper_type = shop.strip().lower()
        scraper_class = scraper_map.get(scraper_type)

        if not scraper_class:
            result.append({"error": f"Unknown scraper type: {scraper_type}"})
            continue
        
        scraper = scraper_class(
            site_name=shop,
            shoping_list=item.shoping_list
        )
        scraped_data = scraper.scrape()

        result.append({
            "site": shop,
            "items": scraped_data
        })

    return {"result": result}
