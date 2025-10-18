from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor

from difflib import SequenceMatcher

from .scraper import Scraper

class AsdaScraper(Scraper):

    def __init__(self, site_name, shoping_list):
        super().__init__(site_name,shoping_list)
        self.base_url = "https://www.asda.com/groceries/search/"

    def get_url(self, product_name):
        return f"{self.base_url}{product_name.replace(' ', '%20')}"

    def scrape_item(self, url):

        driver = self.set_up_driver()
        driver.get(url)

        WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'a[data-locator="txt-product-name"]'))
        )

        return self.page(driver)
    
    def page(self, driver):
        soup = BeautifulSoup(driver.page_source, "html.parser")
        results = []

        product_modules = soup.select("div.css-17zd6fi")

        for product in product_modules:

            name_tag = product.select_one('a[data-locator="txt-product-name"]')
            name = name_tag.get_text(strip=True) if name_tag else None

            price_tag = product.select_one('p[data-locator="txt-product-price"]')
            price = price_tag.get_text(strip=True) if price_tag else None

            unit_tag = product.select_one('p[data-locator="txt-product-price-per-uom"]')
            unit_price = unit_tag.get_text(strip=True) if unit_tag else None

            if name:
                results.append({
                    "name": name,
                    "price": price,
                    "unit_price": unit_price
                })

        driver.quit()
        return results

        