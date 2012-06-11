alias Erlang.erl_scan, as: Scan

defmodule JSON.Scanner do
  def scan(thing) when is_binary(thing) do
    binary_to_list(thing)
  end

  def scan(string) do
    Scan.string(string)
  end
end
