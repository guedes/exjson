defprotocol JSON, [generate(element)]

defimpl JSON, for: Atom do
  def generate(atom), do: Binary.escape(atom_to_binary(atom), ?")
end

defimpl JSON, for: BitString do
  def generate(thing), do: Binary.escape(thing, ?")
end

defimpl JSON, for: Number do
  def generate(integer), do: list_to_binary(integer_to_list(integer))
end

defimpl JSON, for: Tuple do
  def generate({}), do: "{}"

  def generate({ key, value }) when is_tuple(value) do
    JSON.generate(key) <> ":" <> JSON.generate([value])
  end

  def generate({ key, value }) do
    JSON.generate(key) <> ":" <> JSON.generate(value)
  end

end

defimpl JSON, for: List do
  def generate([]), do: "{}"
  def generate([{}]), do: "{}"

  def generate([tuple]) when is_tuple(tuple) do
    "{" <> JSON.generate(tuple) <> "}"
  end

  def generate(list) when is_list(list) do
    Binary.Inspect.inspect(list)
  end

end
