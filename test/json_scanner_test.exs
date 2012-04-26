Code.require_file "../test_helper", __FILE__

#defmodule JSON.Scanner.ScanTest do
#  use ExUnit.Case
#
#  test :empty_json do
#    assert_equal [], JSON.Scanner.json_object("{}")
#  end
#
#  test :simple_kv do
#    assert_equal [ k: "v" ], JSON.Scanner.json_object("{\"k\":\"v\"}")
#  end
#
#  test :string_pair do
#    assert_equal { :k, "v" }, JSON.Scanner.json_pair("\"k\":\"v\"")
#  end
#
#  test :empty_array_pair do
#    assert_equal { :k, [] }, JSON.Scanner.json_pair("\"k\":[]")
#  end
#
#  test :number_array_pair do
#    assert_equal { :k, [ 1, 2, 30 ] }, JSON.Scanner.json_pair("\"k\":[1,2,30]")
#  end
#
#end

defmodule JSON.Scanner.ParseTest do
  use ExUnit.Case

  test :empty_json do
    assert_equal [], JSON.Scanner.decode("{}")
  end

  test :simple_kv do
    assert_equal [ {'key', "value" } ], JSON.Scanner.decode('{"key":"value"}')
  end

  test :rfc4267_json_object do
    # See http://www.ietf.org/rfc/rfc4627.txt
    assert_equal       [ image: [
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
      ], JSON.Scanner.decode('{"image":{"height":600,"ids":[116,943,234,38793],"thumbnail":{"height":125,"url":"http://www.example.com/image/481989943","width":100},"title":"View from 15th Floor","width":800}}')
  end
end
