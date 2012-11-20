# Caching
Cache something
```ruby
begin
  @profile = Geoloqi::Cache.get_fresh(key, ttl) { 
    # This will get cached
  }
rescue
  halt 500
end
```

Remove something from cache
```ruby
Geoloqi::Cache.delete key
```

# Pages

```ruby
# Will search the content folder to page.md
@content = Geoloqi::Pages.find "page"
```

```ruby
# Get all pages in content/api
@content = Geoloqi::Pages.all "api"
```

```ruby
# Get all pages in content/api
before "/api" do 
  @sidebar ||= Geoloqi::Pages.find "api/sidebar"
end
```