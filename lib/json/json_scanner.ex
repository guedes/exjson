defmodule JSON.Scanner do

  def decode(binary) when is_binary(binary) do
    decode(binary_to_list(binary))
  end

  def decode(chars) when is_list(chars) do
    { value, remaining } = parse(ignore_spaces(chars))
    { :ok, value, ignore_spaces(remaining) }
  end

  def parse([?" | rest ]) do
    { codepoints, rest } = parse_string(rest, [])
    { list_to_binary(codepoints), rest }
  end

  def parse("true" <> rest),  do: { true,   rest }
  def parse("false" <> rest), do: { false,  rest }
  def parse("null" <> rest),  do: { nil,    rest }
  def parse([?{ | rest]), do: parse_object(ignore_spaces(rest), [])
  def parse([]), do: "xxxxx"
  def parse(chars), do: "yyyy"

  def parse_string(chars, acc) do
    case parse_codepoint(chars) do
      match: { :done, rest }
        { List.reverse(acc), rest }
      match: { :ok, codepoint, rest }
        parse_string(rest, [ codepoint | acc ])
    end
  end

  def parse_codepoint([?" | rest ]), do: { :done, rest }
  def parse_codepoint([?\\ , key, rest ]), do: parse_general_char(key, rest)
  def parse_codepoint([ x | rest ]), do: { :ok, x, rest }

  def parse_general_char(?", rest), do: { :ok, ?", rest }

  def parse_object([?} | rest ], acc) do
    { {:obj, List.reverse(acc) }, acc }
  end

  def parse_object([?, | rest ], acc) do
    parse_object(ignore_spaces(rest), acc)
  end

  def parse_object([?" | rest ], acc) do   # " vim balance
    { key_codepoints, rest } = parse_string(rest, [])
    [ ?: | rest ] = ignore_spaces(rest)
    { value, rest } = parse(ignore_spaces(rest))
    parse_object(ignore_spaces(rest), [ { key_codepoints, value } | acc ])
  end

  
  def json_object("{}"), do: []

  def json_object(object) do
    regex = %r/\{(.+)\}/

    destructure([_, members ], Regex.run(regex, object))
    [ json_pair(members) ]
  end

  def json_pair(pair) do
    regex = %r/^"(.+)":(.+)$/
    destructure([ _, key, value ], Regex.run(regex, pair))
    { json_string(key, :as_key), json_value(value) }
  end

  def json_string(string, :as_key), do: binary_to_atom(string)
  def json_string(string), do: string

  def json_value("[]"), do: []

  def json_value("\"" <> value) do
    regex = %r/^(.+)"$/
    destructure([ _, string ], Regex.run(regex, value))
    string
  end

  def json_value("[" <> value) do
    regex = %r/^(.+)]$/
    destructure([ _, array ], Regex.run(regex, value))
    json_array(array)
  end

  def json_array(array) do
    result = Regex.split %r/,/, array

    if Regex.match?(%r/^(\d,?)+$/, array) do
      Enum.map(result, fn(x) -> list_to_integer(binary_to_list(x)) end)
    end
  end

  defp ignore_spaces(string) when is_binary(string), do: ignore_spaces(binary_to_list(string))
  defp ignore_spaces([ c | rest ]) when c <= 32, do: ignore_spaces(rest)
  defp ignore_spaces(list), do: list_to_binary(list)
end
