defmodule JSON.Scanner do
  def scan(thing) when is_binary(thing) do
    String.to_char_list!(thing)
  end

  def scan(string) do
    :erl_scan.string(string)
  end
end
