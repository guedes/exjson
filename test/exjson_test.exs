defmodule ExJSON.Test do
  use ExUnit.Case

  @empties [ [], {}, [{}], %{} ]

  @singles [
    [ :name     , "\"name\""  ],
    [ :Name     , "\"Name\""  ],
    [ :"IDs"    , "\"IDs\""   ],
    [ "name"    , "\"name\""  ],
    [ "Name"    , "\"Name\""  ],
    [ "IDs"     , "\"IDs\""   ],
    [ 1         , "1"         ],
    [ 1.0       , "1.0"       ],
    [ 1231.0123 , "1231.0123" ],
  ]

  @numbers [
    [ "-0"                , 0                 ],
    [ "+0"                , 0                 ],
    [ "-123"              , -123              ],
    [ "+123"              , 123               ],
    [ "-3.5"              , -3.5              ],
    [ "+3.5"              , 3.5               ],
    [ "+9876543.57654321" , 9876543.57654321  ],
    [ "-9876543.57654321" , -9876543.57654321 ],
  ]

  test "generate empty json" do
    @empties |> Enum.each fn value ->
      assert ExJSON.generate(value) == "{}"
    end
  end

  test "parse empty json" do
    assert ExJSON.parse("{}") == []
    assert ExJSON.parse("{}", :to_map) == %{}
  end

  test "generate just keys or values" do
    @singles |> Enum.each fn [ value, expected ] ->
      assert ExJSON.generate(value) == expected
    end
  end

  test "number with sign" do
    @numbers |> Enum.each fn [ value, expected ] ->
      assert ExJSON.parse("{ \"value\": #{value} }") == [ { "value", expected } ]
      assert ExJSON.parse("{ \"value\": #{value} }", :to_map) == %{ "value" => expected }
    end
  end

  test "generate a rfc4267 json example object" do
    # See http://www.ietf.org/rfc/rfc4627.txt
    expected = "{\"image\":{\"height\":600,\"ids\":[116,943,234,38793,1.0,-1.9],\"thumbnail\":{\"height\":125,\"url\":\"http://www.example.com/image/481989943\",\"width\":100},\"title\":\"View from 15th Floor\",\"width\":800}}"

    assert ExJSON.generate([
      image: [
          height: 600,
          ids: [ 116, 943, 234, 38793, 1.0, -1.9 ],
          thumbnail: [
            height: 125,
            url: "http://www.example.com/image/481989943",
            width: 100
          ],
          title: "View from 15th Floor",
          width: 800
        ]
    ]) == expected

    assert ExJSON.generate(%{
      image: %{
          height: 600,
          ids: [ 116, 943, 234, 38793, 1.0, -1.9 ],
          thumbnail: %{
            height: 125,
            url: "http://www.example.com/image/481989943",
            width: 100
          },
          title: "View from 15th Floor",
          width: 800
        }
    }) == expected
  end

  test "parse a more complex json" do
    assert ExJSON.parse(
           '{
              "key": "some value",
              "another_key": [ "value1", "another value", "value 3" ],
              "nested_key": {
                "inside_key": "a value",
                "bool_value1": true,
                "bool_value2": false,
                "nil_value": null,
                "neg_value": -47.05,
                "float_value": 421.56
              },
              "tags": [ "test1", "test2", "test3" ],
              "encoded": "знач"
            }') == [
                      { "key", "some value" },
                      { "another_key", [ "value1", "another value", "value 3" ] },
                      { "nested_key", [
                         { "inside_key", "a value" },
                         { "bool_value1", true },
                         { "bool_value2", false },
                         { "nil_value", nil },
                         { "neg_value", -47.05 },
                         { "float_value", 421.56 }
                         ]
                      },
                      { "tags", [ "test1", "test2", "test3" ] },
                      { "encoded", "знач" }
            ]
  end

  test "parse an array of json objects to keyword" do
    assert ExJSON.parse(
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
            )) == [
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

           ]
  end

  test "parse an array of json objects to map" do
    assert ExJSON.parse(
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
            }
            ]
            ), :to_map) == [
            %{
              "key" => "some value",
              "another_key" => [ "value1", "another value", "value 3" ],
              "nested_key" => %{
                 "inside_key" => "a value",
                 "bool_value1" => true,
                 "bool_value2" => false,
                 "nil_value" => nil
               },
              "tags" => [ "test1", "test2", "test3" ]
            },
            %{
              "key" => "some value2",
              "another_key" => [ "value12", "another value2", "value 32" ],
              "nested_key" => %{
                 "inside_key" => "a value2",
                 "bool_value1" => true,
                 "bool_value2" => false,
                 "nil_value" => nil
               },
              "tags" => [ "test12", "test22", "test32" ]
            }
           ]
  end

end
