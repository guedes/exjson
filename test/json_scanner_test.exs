Code.require_file "../test_helper", __FILE__

defmodule JSON.Scanner.ScanTest do
  use ExUnit.Case

  test :empty_json do
    assert_equal [], JSON.Scanner.json_object("{}")
  end

  test :simple_kv do
    assert_equal [ k: "v" ], JSON.Scanner.json_object("{\"k\":\"v\"}")
  end

  test :string_pair do
    assert_equal { :k, "v" }, JSON.Scanner.json_pair("\"k\":\"v\"")
  end

  test :empty_array_pair do
    assert_equal { :k, [] }, JSON.Scanner.json_pair("\"k\":[]")
  end

  test :number_array_pair do
    assert_equal { :k, [ 1, 2, 30 ] }, JSON.Scanner.json_pair("\"k\":[1,2,30]")
  end

end
