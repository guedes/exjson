Code.require_file "../test_helper", __FILE__

defmodule JSON.Scanner.ScanTest do
  use ExUnit.Case

  test :simple_tuple do
    assert {:ok,[{:"{",1},{:string,1,'Name'},{:":",1},{:string,1,'Dickson S. Guedes'},{:"}",1}],1} == JSON.Scanner.scan('{    "Name": "Dickson S. Guedes"   }')
  end
end

