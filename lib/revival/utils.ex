defmodule Revival.Utils do
  def convert_map_keys_to_atoms(map) do
    for {k, v} <- map, do: {String.to_atom(k), v}, into: %{}
  end

  def convert_map_keys_to_strings(map) do
    for {k, v} <- map, do: {to_string(k), v}, into: %{}
  end

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
