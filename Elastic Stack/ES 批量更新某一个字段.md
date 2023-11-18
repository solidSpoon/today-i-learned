

[Alternative installation using Docker](https://github.com/LisaHJung/Part-1-Intro-to-Elasticsearch-and-Kibana/blob/main/docker-compose.yml)

ES 批量更新某一个字段

```
POST pinan_pms/_update_by_query
{
  "script": {
    "source": "ctx._source.retailDiscountPrice=Math.round((ctx._source.price * 0.82) * 100) / 100.0",
    "lang": "painless"
  },
  "query": {
    "term": {
      "id": "224111"
    }
  }
}
```
