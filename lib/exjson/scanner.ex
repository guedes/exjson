defmodule ExJSON.Scanner do
  def scan(thing) when is_binary(thing) do
    List.from_char_data!(thing)
  end

  def scan(string) do
    :erl_scan.string(string)
  end
end
