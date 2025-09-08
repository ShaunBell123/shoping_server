from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

from Scraper import Scraper

class TescoScraper(Scraper):

    def __init__(self):
        super().__init__("Tesco")
    
    def scrape(self):
        user_agent = self.user_agent()
        return f"{user_agent} from {self.site_name}"

