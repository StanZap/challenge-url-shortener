## URL Shortener

This is an extremely simple url shortener API powered by Laravel 5. The short links were generated using the php implementation of the awesome [hashids](http://hashids.org/php) library. 

### Setup
Go inside the project directory and run:
```bash
$ touch ./database/database.sqlite
$ docker-compose up -d
```

### Use
Start using the API with you favorite API Client and just send a `POST` request to `/api/links` with a property `link` like:
```json
{
    "link": "http://example.com/this/is/some/example/url.html"
}
```
that should return something like:
```json
{
  "short_url": "http://localhost:8000/mO"
}

```
Simple. You can get the Top 100 links accessed by calling `/api/top-100-links`
