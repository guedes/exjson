defprotocol JSONSerialization, [to_json(element)]

defimpl JSONSerialization, for: Tuple do
  def to_json({ key, value }) do
    convert_to_json({ key, value})
  end

  defp convert_to_json({ key, value }) when is_binary(key) and is_binary(value) do
    "{ '#{key}': '#{value}' }"
  end
  
  defp convert_to_json({ key, value }) when is_atom(key) and is_binary(value) do
    "{ '#{atom_to_binary(key, :utf8)}': '#{value}' }"
  end

  defp convert_to_json({ key, value }) when is_atom(key) and is_tuple(value) do
    "{ '#{atom_to_binary(key, :utf8)}': #{convert_to_json(value)} }"
  end
end
