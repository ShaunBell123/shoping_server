# Changelog

## [1.0.2] - 2025-10-10
### Added
- Added a few templates to test user experiences: pages for login, index (home), and dashboard.
### changed 
- Changed to `ScrapeController` to better align with what the Python endpoint (`process`) is expecting.

## [1.0.1] - 2025-10-06
### Added
- Redis caching: when the process endpoint is triggered, the app now checks the cache before scraping new data.
- Auth0 integration: added user authentication to the Java scrape endpoint.
### Changed
- Updated some data structures for improved performance and clarity. in the main file
- moved some file around like asda_scraper and trsco_scraper into a new file called scrap. 

## [1.0.0] - idk(when the repo was made)
### Added
- Initial project setup combining different repositories.
