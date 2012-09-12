defprotocol JSON.Generator do
  def generate(element)
end

defimpl JSON.Generator, for: Atom do
  def generate(atom), do: String.Inspect.Utils.escape(atom_to_binary(atom), ?")
end

defimpl JSON.Generator, for: BitString do
  def generate(thing), do: String.Inspect.Utils.escape(thing, ?")
end

defimpl JSON.Generator, for: Number do
  def generate(number), do: "#{number}"
end

defimpl JSON.Generator, for: Tuple do
  def generate({}), do: "{}"

  def generate({key, value}) do
    "#{JSON.Generator.generate(key)}:#{JSON.Generator.generate(value)}"
  end
end

defimpl JSON.Generator, for: List do
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
    Enum.join(Enum.map(list, JSON.Generator.generate(&1)),",")
  end

  defp has_tuple?(list) when is_list(list) do
    Enum.any?(list, fn(x) -> is_tuple(x) end)
  end

  defp has_tuple?(_) do
    false
  end
end
