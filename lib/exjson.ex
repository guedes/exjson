defmodule ExJSON do
  @moduledoc """
  This module is responsible to generate and parse JSON.
  """

  @doc """
  Creates a JSON document from an Elixir keyword list or map.

  ## Examples

      iex> ExJSON.generate([ {"hello", "world"}, { "its", ["is", "very", "nice" ]}])
      #=> "{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}"
      iex> ExJSON.generate(%{ "hello" => "world", "its" => ["is", "very", "nice" ] })
      #=> "{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}"
  """
  def generate(thing), do: ExJSON.Generator.generate(thing)

  @doc """
  Creates an Elixir structure from a JSON document. By default ExJSON
  returns a Keyword list unless you specify `:to_map`, then a Map is
  returned.

  ## Examples

      iex> json = ExJSON.parse("{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}")
      #=> [{"hello","world"},{"its",["is","very","nice"]}]
      iex> json["its"] |> Enum.join " "
      #=> "is very nice"

      iex> json_map = ExJSON.parse("{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}", :to_map)
      #=> %{ "hello" => "world", "its" => ["is","very","nice"] }
      iex> json_map["its"] |> Enum.join " "
      #=> "is very nice"

  """
  def parse(thing, return_type \\ :to_keyword), do: ExJSON.Parser.parse(thing, return_type)

end

