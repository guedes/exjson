defmodule ExJSON.Map.ParseTest do
  use ExUnit.Case


  test :to_map do
    assert %{ "key" => "some value" } == ExJSON.Map.to_map("{\"key\":\"some value\"}")
  end


  test :string_array_test do
    assert ExJSON.Map.to_map('{ "another_key": [ "value1", "another value", "value 3" ] }') == %{ "another_key" => [ "value1", "another value", "value 3" ] }
  end

  test :nested_key_values do
    some_json = '{ "key": "value", "k1": "vvv", "another_key": { "k1": "v1", "k2": "v2", "k3": { "k31": 10 }, "k4": "v4" } }'

    generated_map = ExJSON.Map.to_map(some_json)

    assert generated_map["another_key"]["k1"] == "v1"
    assert generated_map["another_key"]["k2"] == "v2"
    assert generated_map["another_key"]["k3"]["k31"] == 10
    assert generated_map["another_key"]["k4"] == "v4"
    assert generated_map["key"] == "value"
    assert generated_map["k1"] == "vvv"
  end


end
