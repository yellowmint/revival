defmodule Revival.Utils do
  def convert_map_keys_to_atoms(map) do
    for {k, v} <- map, do: {String.to_atom(k), v}, into: %{}
  end

  def convert_map_keys_to_strings(map) do
    for {k, v} <- map, do: {to_string(k), v}, into: %{}
  end

  def keys_to_atoms(json) when is_map(json), do: Map.new(json, &reduce_keys_to_atoms/1)
  def keys_to_atoms(list) when is_list(list), do: Enum.map(list, &keys_to_atoms/1)
  def keys_to_atoms(nil), do: nil

  def reduce_keys_to_atoms({key, val}) when is_map(val), do: {String.to_existing_atom(key), keys_to_atoms(val)}
  def reduce_keys_to_atoms({key, val}) when is_list(val), do: {String.to_existing_atom(key), Enum.map(val, &keys_to_atoms(&1))}
  def reduce_keys_to_atoms({key, val}), do: {String.to_existing_atom(key), val}

  def validate_unique_list_items_by_id(changeset, field) do
    Ecto.Changeset.validate_change(changeset, field, fn _, list ->
      ids = Enum.map(list, fn x -> x.id end)

      case Enum.uniq(ids) do
        ^ids -> []
        _ -> [{field, "list contains duplication"}]
      end
    end)
  end
end
