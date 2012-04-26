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
  def parse([?[ | rest]), do: parse_array(ignore_spaces(rest), [])

  def parse([]), do: exit(:unexpected_end_of_input)
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

  def finish_number(acc, rest) do
    str = List.reverse(acc)
    {
    case list_to_integer(str) do
      match: {'EXIT', _} 
        list_to_float(str)
      match: value
	 value
    end, 
    rest
    }
  end
  
  def parse_number([?- | rest], acc) do
    parse_signed_number(rest, [?- | acc])
  end
  
  def parse_number(rest = [c | _], acc) do
    case is_digit(c) do
      match: true 
        parse_signed_number(rest, acc)
      match: false
        exit(:syntax_error)
    end
  end

  def parse_signed_number(rest, acc) do
    { acc, rest } = parse_int_part(rest, acc)
    case rest do
      match: []
        finish_number( acc, [])
      match: [?. | more]
        { acc, rest } = parse_int_part(more, [?. | acc])
        parse_exp(rest, acc, false)
      else:
        parse_exp(acc, rest, true)
    end
  end

  def parse_int_part(chars = [_ch | _rest], acc) do
    parse_int_part0(chars, acc)
  end

  def parse_int_part0([], acc) do
    { acc, [] }
  end

  def parse_int_part0([ch | rest], acc) do
    case is_digit(ch) do
      match: true
        parse_int_part0(rest, [ch | acc])
      match: false
        { acc, [ch | rest] }
    end
  end

  def parse_exp([?e | rest], acc, needfrac) do
    parse_exp1(rest, acc, needfrac)
  end

  def parse_exp([?E | rest], acc, needfrac) do
    parse_exp1(rest, acc, needfrac)
  end

  def parse_exp(rest, acc, _needfrac) do
    finish_number(acc, rest)
  end
  
  def parse_exp1(rest, acc, needfrac) do
    {acc, rest} = parse_signed_int_part(
                          rest, 
                          if needfrac do
                            [?e, ?0, ?. | acc]
                          else:
                            [?e | acc]
			  end)

    finish_number(acc, rest)
  end

  def parse_signed_int_part([?+ | rest], acc) do
    parse_int_part(rest, [?+ | acc])
  end

  def parse_signed_int_part([?- | rest], acc) do
    parse_int_part(rest, [?- | acc])
  end

  def parse_signed_int_part(rest, acc) do
    parse_int_part(rest, acc)
  end

  def is_digit(n) when is_integer(n), do: n >= ?0 && n <= ?9
  def is_digit(_), do: false

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

  def parse_array([?] | rest], acc) do
    { Lists.reverse(acc), rest }
  end

  def parse_array([?, | rest], acc) do
    parse_array(ignore_spaces(rest), acc)
  end

  def parse_array(chars, acc) do
    { value, rest } = parse(chars)
    parse_array(ignore_spaces(rest), [value | acc])
  end

defp ignore_spaces(string) when is_binary(string), do: ignore_spaces(binary_to_list(string))
  defp ignore_spaces([ c | rest ]) when c <= 32, do: ignore_spaces(rest)
  defp ignore_spaces(chars), do: chars
end
