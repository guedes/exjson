Code.require_file "../test_helper.exs", __FILE__

defmodule JSON.Parser.ParseTest do
  use ExUnit.Case

  test :simple_tuple do
    assert [ { "key", "some value" } ] == JSON.parse("{\"key\":\"some value\"}")
  end

  test :string_array_test do
    assert [ { "another_key", [ "value1", "another value", "value 3" ] } ] == JSON.parse('{ "another_key": [ "value1", "another value", "value 3" ] }')
  end

  test :integer_array_test do
    assert [ { "another_key", [ 1, 2, 3 ] } ] == JSON.parse('{ "another_key": [ 1, 2, 3 ] }')
  end

  test :three_keys do
    assert [
            { "k1", "v1" },
            { "k2", "v2" },
            { "k3", "v3" }
           ] == JSON.parse(
           '{
              "k1": "v1",
              "k2": "v2",
              "k3": "v3"
            }')
  end

  test :nested_key_values do
    assert [
            { "key", "value" },
            { "another_key", [
                { "k1", "v1" },
                { "k2", "v2" },
                { "k3", "v3" }
              ]
            }
           ] == JSON.parse(
           '{
              "key": "value",
              "another_key": {
                "k1": "v1",
                "k2": "v2",
                "k3": "v3"
              }
            }')
  end

  test :more_complex_json do
    assert [
            { "key", "some value" },
            { "another_key", [ "value1", "another value", "value 3" ] },
            { "nested_key", [
               { "inside_key", "a value" },
               { "bool_value1", true },
               { "bool_value2", false },
               { "nil_value", nil }
               ]
            },
            { "tags", [ "test1", "test2", "test3" ] }
           ] == JSON.parse(
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
  end

  test :array_object_minimal do
    assert [
            [ {"a","b"}, {"c","d"} ],
            [ {"a1","b1"}, {"c1","d1"} ],
            [ {"a2","b2"}, {"c2","d2"} ]
           ] == JSON.parse('[
                             { "a": "b", "c": "d" },
                             { "a1": "b1", "c1": "d1" },
                             { "a2": "b2", "c2": "d2" }
                            ]')
  end

  test :array_object do
    assert [
            [
              { "key", "some value" },
              { "another_key", [ "value1", "another value", "value 3" ] },
              { "nested_key", [
                 { "inside_key", "a value" },
                 { "bool_value1", true },
                 { "bool_value2", false },
                 { "nil_value", nil }
                 ]
              },
              { "tags", [ "test1", "test2", "test3" ] }
            ],
            [
              { "key", "some value2" },
              { "another_key", [ "value12", "another value2", "value 32" ] },
              { "nested_key", [
                 { "inside_key", "a value2" },
                 { "bool_value1", true },
                 { "bool_value2", false },
                 { "nil_value", nil }
                 ]
              },
              { "tags", [ "test12", "test22", "test32" ] }
            ],
            [
              { "key", "some value2" },
              { "another_key", [ "value12", "another value2", "value 32" ] },
              { "nested_key", [
                 { "inside_key", "a value2" },
                 { "bool_value1", true },
                 { "bool_value2", false },
                 { "nil_value", nil }
                 ]
              },
              { "tags", [ "test12", "test22", "test32" ] }
            ]

           ] == JSON.parse(
           %b([{
              "key": "some value",
              "another_key": [ "value1", "another value", "value 3" ],
              "nested_key": {
                "inside_key": "a value",
                "bool_value1": true,
                "bool_value2": false,
                "nil_value": null
              },
              "tags": [ "test1", "test2", "test3" ]
            },
            {
              "key": "some value2",
              "another_key": [ "value12", "another value2", "value 32" ],
              "nested_key": {
                "inside_key": "a value2",
                "bool_value1": true,
                "bool_value2": false,
                "nil_value": null
              },
              "tags": [ "test12", "test22", "test32" ]
            },
            {
              "key": "some value2",
              "another_key": [ "value12", "another value2", "value 32" ],
              "nested_key": {
                "inside_key": "a value2",
                "bool_value1": true,
                "bool_value2": false,
                "nil_value": null
              },
              "tags": [ "test12", "test22", "test32" ]
            }]
            ))
  end
end

