defmodule JSON.Scanner do
  @moduledoc """
  This module is an Elixir porting of the
  JSON RFC 4627 implementation for Erlang.

  See: https://github.com/tonyg/erlang-rfc4627/blob/master/src/rfc4627.erl

  Erlang version's authors:
  - Tony Garnock-Jones <tonygarnockjones@gmail.com>
  - LShift Ltd. <query@lshift.net>

  Elixir version's author:
    Dickson S. Guedes <guedes@guedesoft.net>

  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation
  files (the "Software"), to deal in the Software without
  restriction, including without limitation the rights to use, copy,
  modify, merge, publish, distribute, sublicense, and/or sell copies
  of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  """

  def decode(binary) when is_binary(binary) do
    decode(binary_to_list(binary))
  end

  def decode(chars) when is_list(chars) do
    { value, remaining } = parse(ignore_spaces(chars))
    {_ ,  json_object } = value
    json_object
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
  def parse(chars), do: parse_number(chars, [])

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

  def parse_number(a, b) do
    999
  end

  #def parse_number([?- | rest], acc) do
  #  parse_signed_number(rest, [?- | acc])
  #end

  #def parse_signed_number(rest, acc) do
  #  { acc, rest } = parse_int_part(rest, acc)
  #  case rest do
  #    match: []
  #      finish_number( acc, [])
  #    match: [?. | more]
  #      { acc, rest } = parse_int_part(more, [?. | acc])
  #      parse_exp(rest, acc, false)
  #    else:
  #      parse_exp(acc, rest)
  #  end
  #end

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


  #def json_object("{}"), do: []

  #def json_object(object) do
  #  regex = %r/\{(.+)\}/

  #  destructure([_, members ], Regex.run(regex, object))
  #  [ json_pair(members) ]
  #end

  #def json_pair(pair) do
  #  regex = %r/^"(.+)":(.+)$/
  #  destructure([ _, key, value ], Regex.run(regex, pair))
  #  { json_string(key, :as_key), json_value(value) }
  #end

  #def json_string(string, :as_key), do: binary_to_atom(string)
  #def json_string(string), do: string

  #def json_value("[]"), do: []

  #def json_value("\"" <> value) do
  #  regex = %r/^(.+)"$/
  #  destructure([ _, string ], Regex.run(regex, value))
  #  string
  #end

  #def json_value("[" <> value) do
  #  regex = %r/^(.+)]$/
  #  destructure([ _, array ], Regex.run(regex, value))
  #  json_array(array)
  #end

  #def json_array(array) do
  #  result = Regex.split %r/,/, array

  #  if Regex.match?(%r/^(\d,?)+$/, array) do
  #    Enum.map(result, fn(x) -> list_to_integer(binary_to_list(x)) end)
  #  end
  #end

  defp ignore_spaces(string) when is_binary(string), do: ignore_spaces(binary_to_list(string))
  defp ignore_spaces([ c | rest ]) when c <= 32, do: ignore_spaces(rest)
  defp ignore_spaces(chars), do: chars
end
