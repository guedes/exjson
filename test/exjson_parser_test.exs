defmodule ExJSON.Parser.ParseTest do
  use ExUnit.Case

  test :simple_tuple do
    assert [ { "key", "some value" } ] == ExJSON.Parser.parse("{\"key\":\"some value\"}")
  end

  test :string_array_test do
    assert [ { "another_key", [ "value1", "another value", "value 3" ] } ] == ExJSON.Parser.parse('{ "another_key": [ "value1", "another value", "value 3" ] }')
  end

  test :integer_array_test do
    assert [ { "another_key", [ 1, 2, 3 ] } ] == ExJSON.Parser.parse('{ "another_key": [ 1, 2, 3 ] }')
  end

  test :three_keys do
    assert [
            { "k1", "v1" },
            { "k2", "v2" },
            { "k3", "v3" }
           ] == ExJSON.Parser.parse(
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
           ] == ExJSON.Parser.parse(
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
            { "tags", [ "test1", "test2", "test3" ] },
            { "encoded", "знач" }
           ] == ExJSON.Parser.parse(
           '{
              "key": "some value",
              "another_key": [ "value1", "another value", "value 3" ],
              "nested_key": {
                "inside_key": "a value",
                "bool_value1": true,
                "bool_value2": false,
                "nil_value": null
              },
              "tags": [ "test1", "test2", "test3" ],
              "encoded": "знач"
            }')
  end

  test :array_object_minimal do
    assert [
            [ {"a","b"}, {"c","d"} ],
            [ {"a1","b1"}, {"c1","d1"} ],
            [ {"a2","b2"}, {"c2","d2"} ]
           ] == ExJSON.Parser.parse('[
                             { "a": "b", "c": "d" },
                             { "a1": "b1", "c1": "d1" },
                             { "a2": "b2", "c2": "d2" }
                            ]')
  end

  test :signed_numbers do
    assert [ { "value", 0 } ] == ExJSON.Parser.parse('{ "value": -0 }')
    assert [ { "value", 0 } ] == ExJSON.Parser.parse('{ "value": +0 }')

    assert [ { "value", -123 } ] == ExJSON.Parser.parse('{ "value": -123 }')
    assert [ { "value", 123 } ] == ExJSON.Parser.parse('{ "value": +123 }')

    assert [ { "value", -3.5 } ] == ExJSON.Parser.parse('{ "value": -3.5 }')
    assert [ { "value", 3.5 } ] == ExJSON.Parser.parse('{ "value": +3.5 }')

    assert [ { "value", 9876543.57654321 } ] == ExJSON.Parser.parse('{ "value": +9876543.57654321 }')
    assert [ { "value", -9876543.57654321 } ] == ExJSON.Parser.parse('{ "value": -9876543.57654321 }')
  end

  test :brackets_inside_string do
    assert ExJSON.Parser.parse('{"output_wrap_begin":"[[","output_wrap_end":"]]"}') == [ {"output_wrap_begin" , "[[" }, { "output_wrap_end", "]]" } ]
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

           ] == ExJSON.Parser.parse(
           ~s([{
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

