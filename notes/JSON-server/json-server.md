# Install json-server (GLOBALLY)

```bash
# install
npm install json-server -g

# run
json-server --watch db.json --port 3034
```

* Example JSON

```js
{
  "names": [
    {
      "id":1,
      "name":"Chris"
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
