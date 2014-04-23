JSON for Elixir
===============

[Elixir](http://elixir-lang.org) implementation (with an Erlang parser) of the [JSON](http://www.json.org) specification to [RFC 4627](http://www.ietf.org/rfc/rfc4627.txt). ExJSON generate JSON string from keyword lists and maps and can parse into those structures also.

## Generating a JSON string from a keyword list

```elixir
 ExJSON.generate([ key: "some value" ])
 #=> "{\"key\":\"some value\"}"

 ExJSON.generate([ k: [ 1, 2, 3 ] ])
 #=> "{\"k\":[1,2,3]}"

 ExJSON.generate([ k1: [ k2: [ k3: "v3" ] ] ])
 #=> "{\"k1\":{\"k2\":{\"k3\":\"v3\"}}}"

 ExJSON.generate([
    image: [
      width: 800,
      height: 600,
      title: "View from 15th Floor",
      thumbnail: [
        url: "http://www.example.com/image/481989943",
        height: 125,
        width: 100
      ],
      ids: [ 116, 943, 234, 38793 ]
    ]
 ])
 #=> "{\"image\":{\"height\":600,\"ids\":[116,943,234,38793],\"thumbnail\":{\"height\":125,\"url\":\"http://www.example.com/image/481989943\",\"width\":100},\"title\":\"View from 15th Floor\",\"width\":800}}"
```
## Generating a JSON string from a map

```elixir
 ExJSON.generate(%{
  location: %{
    lat: -47.8,
    lng:  23.8
  },
  name: "The name",
  phone: "666-6666",
  urls: [
   "http://example1.org",
   "http://example2.org"
  ]
 })
 #=> "{\"location\":{\"lat\":-47.8,\"lng\":23.8},\"name\":\"The name\",\"phone\":\"666-6666\",
 \"urls\":[\"http://example1.org\",\"http://example2.org\"]}"
```

## Parsing JSON string to keyword list

```elixir
 ExJSON.parse(
 '{
   "key": "value",
   "another_key": {
     "k1": "v1",
     "k2": "v2",
     "k3": "v3"
   }
 }')
 #=> [ { "key", "value" }, { "another_key", [ { "k1", "v1" }, { "k2", "v2" }, { "k3", "v3" } ] } ]

 ExJSON.parse(
 '{
    "key": "some value",
    "another_key": [ "value1", "another value", "value 3" ],
    "nested_key": {
      "inside_key": "a value",
      "bool_value1": true,
      "bool_value2": false,
      "nil_value": null
    },
    "tags": [ "test1", "test2", "test3" ]
 }')
 #=> [ { "key", "some value" }, { "another_key", [ "value1", "another value", "value 3" ] }, { "nested_key", [ { "inside_key", "a value" }, { "bool_value1", true }, { "bool_value2", false }, { "nil_value", nil } ] }, { "tags", [ "test1", "test2", "test3" ] } ]
```

## Parsing JSON string to map

```elixir
 ExJSON.parse_to_map('{
  "location": {
    "lat": -47.8,
    "lng": 23.8
  },
  "name": "The name",
  "phone": "666-6666",
  "urls": [
    "http://example1.org",
    "http://example2.org"
  ]
 }')
 #=> %{"location" => %{"lat" => -47.8, "lng" => 23.8}, "name" => "The name",
      "phone" => "666-6666",
      "urls" => ["http://example1.org", "http://example2.org"]}
```

## License

Copyright 2012,2013,2014 Dickson S. Guedes.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
