from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup

from difflib import SequenceMatcher

from .scraper import Scraper

class TescoScraper(Scraper):

    def __init__(self, site_name, shoping_list):
        super().__init__(site_name,shoping_list)
        self.base_url = "https://www.tesco.com/groceries/en-GB/search?query="

    def scrape(self):

        all_results = []

        for item in self.shoping_list:

            search_query = item.replace(" ", "+")
            url = self.base_url + search_query
            driver = self.set_up_driver()

            driver.get(url)

            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "ul#list-content li"))
            )

            page_contents = self.page(driver)

            filter_page_contents = self.closest_product(item,page_contents)

            all_results.append({item: filter_page_contents})

        return all_results
    
    def page(self, driver):

        soup = BeautifulSoup(driver.page_source, "html.parser")
        items = soup.select("ul#list-content li")

        results = []

        for item in items:
            name_tag = item.select_one("a.a59700_Iwyiba_titleLink")
            name = name_tag.text.strip() if name_tag else None

            price_tag = item.select_one("p.a59700_FKk1BW_priceText")
            price = price_tag.text.strip() if price_tag else None

            unit_tag = item.select_one("p.a59700_FKk1BW_subtext")
            unit_price = unit_tag.text.strip() if unit_tag else None
            
            results.append({"name": name, "price": price, "unit_price": unit_price})

        driver.quit()

        return results