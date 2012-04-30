JSON for Elixir
===============

This is a work-in-progress [JSON](http://www.ietf.org/rfc/rfc4627.txt) parser and genarator in [Elixir](http://elixir-lang.org).

## Generating JSON from Elixir

```elixir
 JSON.generate([ key: "some value" ])
 #=> "{\"key\":\"some value\"}"

 JSON.generate([ k: [ 1, 2, 3 ] ])
 #=> "{\"k\":[1,2,3]}"

 JSON.generate([ k1: [ k2: [ k3: "v3" ] ] ])
 #=> "{\"k1\":{\"k2\":{\"k3\":\"v3\"}}}"

 JSON.generate([
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

## Parsing JSON to Elixir

```elixir
 JSON.parse(
 '{
   "key": "value",
   "another_key": {
     "k1": "v1",
     "k2": "v2",
     "k3": "v3"
   }
 }')
 #=> [ { "key", "value" }, { "another_key", [ { "k1", "v1" }, { "k2", "v2" }, { "k3", "v3" } ] } ]

 JSON.parse(
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

## License

Copyright 2012 Dickson S. Guedes.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
