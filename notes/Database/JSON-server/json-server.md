# Install json-server (GLOBALLY)

```bash
# install
npm install json-server -g

# run
json-server --watch db.json --port 3034

# Create alias in zsh (recommended)
alias jserv="json-server --watch db.json --port 3034"
```

## Possible Routes :
##### General:
```
GET    /posts
GET    /posts/1
POST   /posts
PUT    /posts/1
PATCH  /posts/1
DELETE /posts/1
```

##### Filter: 
```
GET /posts?id=1&id=2
GET /comments?author.name=typicode
```

##### Sort:
```
GET /posts?_sort=views&_order=asc
GET /posts/1/comments?_sort=votes&_order=asc
```

##### Slice :
```
GET /posts?_start=20&_end=30
GET /posts/1/comments?_start=20&_end=30
GET /posts/1/comments?_start=20&_limit=10
```

##### Operators:
```
_gte    greater than
_lte    less than
_ne     not equals
_like   consists
q       search
```

##### Relationships:
```
Include children:
GET /posts?_embed=comments
GET /posts/1?_embed=comments
Include Parent:
GET /comments?_expand=post
GET /comments/1?_expand=post
```

##### Database:
```
GET /db
```

##### Web server: ./public/index.html can be served
```
GET /
```

### Example JSON

```js
{
  "names": [
    {
      "id":1,
      "name":"Chris",
      "locationId":1
    },
    {
      "id":2,
      "name":"Kang"
    }
  ],
  "locations" : [
    {
      "id":1,
      "name":"1 street NZ"
    }
  ]
}
```
