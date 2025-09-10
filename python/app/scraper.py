from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from bs4 import BeautifulSoup
from difflib import SequenceMatcher

class Scraper:

    def __init__(self, site_name, shoping_list):
        self.site_name = site_name
        self.shoping_list = shoping_list

    def scrape(self):
        return f"Scraping {self.site_name} from a generic shop."
    
    def set_up_driver(self):
        user_agent = self.user_agent()

        options = Options()
        options.add_argument(f"user-agent={user_agent}")
        options.add_argument("--headless=new")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        options.binary_location = "/usr/bin/chromium"
        service = Service("/usr/bin/chromedriver")      
        driver = webdriver.Chrome(service=service, options=options)

        return driver
    
    def user_agent(self):

        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " \
             "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36"

        return user_agent
    
    def closest_product(self, item, products):
        best_match = None
        highest_ratio = 0

        for product in products:
            name = product["name"]
            if not name:
                continue
            ratio = SequenceMatcher(None, item.lower(), name.lower()).ratio()
            if ratio > highest_ratio:
                highest_ratio = ratio
                best_match = product

        return best_match