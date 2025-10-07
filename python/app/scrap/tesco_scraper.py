from app.cashe.redis_cache import RedisCache
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor

from difflib import SequenceMatcher

from .scraper import Scraper

class TescoScraper(Scraper):

    def __init__(self, site_name, shoping_list):
        super().__init__(site_name,shoping_list)
        self.base_url = "https://www.tesco.com/groceries/en-GB/search?query="
    
    def get_url(self, product_name):
        return f"{self.base_url}{product_name.replace(' ', '+')}"
    
    def scrape_item(self, url):

        driver = self.set_up_driver()

        driver.get(url)

        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "ul#list-content li"))
        )

        return self.page(driver)
    
    def page(self, driver):
        soup = BeautifulSoup(driver.page_source, "html.parser")
        items = soup.select("ul#list-content li")

        results = []

        for item in items:

            name_tag = item.select_one("a._64Yvfa_titleLink")
            name = name_tag.get_text(strip=True) if name_tag else None

            price_tag = item.select_one("p._64Yvfa_priceText")
            price = price_tag.get_text(strip=True) if price_tag else None

            unit_tag = item.select_one("p._64Yvfa_subtext")
            unit_price = unit_tag.get_text(strip=True) if unit_tag else None

            if name:
                results.append({
                    "name": name,
                    "price": price,
                    "unit_price": unit_price
                })

        driver.quit()

        return results
    