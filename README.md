## Challenge

1. Test-drive a route `GET /artists`, which returns the list of artists:
```
# Request:
GET /artists

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone
```

2. Test-drive a route `POST /artists`, which creates a new artist in the database. Your test should verify the new artist is returned in the response of `GET /artists`.

```
# Request:
POST /artists

# With body parameters:
name=Wild nothing
genre=Indie

# Expected response (200 OK)
(No content)

# Then subsequent request:
GET /artists

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing
```