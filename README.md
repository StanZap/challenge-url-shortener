## URL Shortener

This is an extremely simple url shortener API powered by Laravel 5. The short links were generated using the php implementation of the awesome [hashids](http://hashids.org/php) library. 

### Setup
You can setup this api project by cloning the repo and in the root folder run:
```bash
$ touch ./database/database.sqlite
$ docker-compose up -d
```
Or you can simply run it as a standalone container
```bash
$ docker run -tid -p 8000:8000 --name shortener jrszapata/url-shortener-laravel-5.8
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
Simple. Now you should be able to start getting a list of top 100 accessed links by calling `/api/top-100-links`.
