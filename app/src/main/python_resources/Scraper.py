class Scraper:

    def __init__(self, site_name):
        self.site_name = site_name

    def scrape(self):
        return f"Scraping {self.site_name} from a generic shop."
    
    def user_agent(self):
        return "Generic User Agent"