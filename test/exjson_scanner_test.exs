defmodule ExJSON.Scanner.ScanTest do
  use ExUnit.Case

  test :simple_tuple do
    assert {:ok,[{:"{",1},{:string,1,'Name'},{:":",1},{:string,1,'Dickson S. Guedes'},{:"}",1}],1} == ExJSON.Scanner.scan('{    "Name": "Dickson S. Guedes"   }')
  end
end

