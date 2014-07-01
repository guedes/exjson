defprotocol ExJSON.Generator do
  def generate(element)
end

defimpl ExJSON.Generator, for: Atom do
  def generate(atom), do: inspect(Atom.to_string(atom))
end

defimpl ExJSON.Generator, for: BitString do
  def generate(thing), do: inspect(thing)
end

defimpl ExJSON.Generator, for: Float do
  def generate(number), do: "#{number}"
end

defimpl ExJSON.Generator, for: Integer do
  def generate(number), do: "#{number}"
end

defimpl ExJSON.Generator, for: Tuple do
  def generate({}), do: "{}"

  def generate({key, value}) do
    "#{ExJSON.Generator.generate(key)}:#{ExJSON.Generator.generate(value)}"
  end
end

defimpl ExJSON.Generator, for: Map do
  def generate(map) do
      map |> Dict.to_list |> ExJSON.Generator.generate
  end
end

defimpl ExJSON.Generator, for: List do
  def generate([]), do: "{}"
  def generate([{}]), do: "{}"

  def generate(list) do
    if has_tuple?(list) do
      "{#{jsonify(list)}}"
    else
      "[#{jsonify(list)}]"
    end
  end

  defp jsonify(list) do
    Enum.join(Enum.map(list, &ExJSON.Generator.generate(&1)),",")
  end

  defp has_tuple?(list) when is_list(list) do
    Enum.any?(list, fn(x) -> is_tuple(x) end)
  end

  defp has_tuple?(_) do
    false
  end
end
