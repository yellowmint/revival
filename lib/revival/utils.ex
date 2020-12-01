defmodule Revival.Utils do
  def convert_map_keys_to_atoms(map) do
    for {k, v} <- map, do: {String.to_atom(k), v}, into: %{}
  end

  def convert_map_keys_to_strings(map) do
    for {k, v} <- map, do: {to_string(k), v}, into: %{}
  end
end
