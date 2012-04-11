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

  def generate({ key, value }) when is_list(value) do
    JSON.List.container_join(tuple_to_list({ key, value }), "{", "}")
  end
  
  def generate({ key, value }) do
    JSON.List.container_join(tuple_to_list({ key, value }), "{", "}")
  end

end

defimpl JSON, for: List do
  def generate([]), do: "{}"

  def generate([tuple]) when is_tuple(tuple) do
    JSON.generate(tuple)
  end

  def generate(list) when is_list(list) do
    container_join(list, "[", "]")
  end

  def container_join([h], acc, last) do
    acc <> JSON.generate(h) <> last
  end

  def container_join([h|t], acc, last) when is_list(t) do
    acc = acc <> JSON.generate(h) <> ":"
    container_join(t, acc, last)
  end

  def container_join([h|t], acc, last) do
    acc <> JSON.generate(h) <> "|" <> JSON.generate(t) <> last
  end

  def container_join([], acc, last) do
    acc <> last
  end
end
