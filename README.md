java, gradle, sprint boot, pthon, fastapi, git, docker
## Have
### Java Container

#### Features
- Uses Auth0 for user authentication.
- Requires the user to be authenticated to call the Python container.

#### Endpoints
`POST /api/private/scrape`

###### Description
User sends a list of shops and items. The Java container calls the Python container and returns the most relevant items per shop.

###### Request Payload
```json
{
  "items": ["milk", "bread", "eggs"],
  "shops": ["ShopA", "ShopB"]
}
```

### Python Container

#### Features
- Handles the actual scraping logic.

#### Endpoints
`POST /process`

###### Description
Receives a list of shops and items from the Java container, scrapes the name, prices, and unit prices, and returns the most relevant items for each item per shop.

###### Request Payload
```json
{
  "items": ["milk", "bread", "eggs"],
  "shops": ["ShopA", "ShopB"]
}
```

## Thing to add
