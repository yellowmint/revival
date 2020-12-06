defmodule Revival.Games.Unit do
  alias Revival.Games.Unit

  @derive Jason.Encoder
  defstruct [:column, :row, :kind, :level, :live, :attack, :label]

  def new_from_shop_good(good, column, row, label) do
    unit(good.kind, good.level)
    |> Map.put(:column, column)
    |> Map.put(:row, row)
    |> Map.put(:label, label)
  end

  defp unit("satyr", 1), do: %Unit{kind: "satyr", level: 1, live: 15, attack: 10}
  defp unit("satyr", 2), do: %Unit{kind: "satyr", level: 2, live: 35, attack: 15}
  defp unit("satyr", 3), do: %Unit{kind: "satyr", level: 3, live: 50, attack: 20}
  defp unit("golem", 1), do: %Unit{kind: "golem", level: 1, live: 40, attack: 5}
  defp unit("golem", 2), do: %Unit{kind: "golem", level: 2, live: 90, attack: 10}
  defp unit("golem", 3), do: %Unit{kind: "golem", level: 3, live: 140, attack: 15}
  defp unit("minotaur", 1), do: %Unit{kind: "minotaur", level: 1, live: 30, attack: 25}
  defp unit("minotaur", 2), do: %Unit{kind: "minotaur", level: 2, live: 70, attack: 50}
  defp unit("minotaur", 3), do: %Unit{kind: "minotaur", level: 3, live: 110, attack: 80}
  defp unit("wraith", 1), do: %Unit{kind: "wraith", level: 1, live: 35, attack: 35}
  defp unit("wraith", 2), do: %Unit{kind: "wraith", level: 2, live: 80, attack: 80}
  defp unit("wraith", 3), do: %Unit{kind: "wraith", level: 3, live: 150, attack: 150}
end
