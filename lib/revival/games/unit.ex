defmodule Revival.Games.Unit do
  alias Revival.Games.Unit

  @derive Jason.Encoder
  defstruct [:column, :row, :kind, :level, :live, :attack, :speed, :label]

  def new_from_shop_good(good, column, row, label) do
    new_unit(good.kind, good.level)
    |> Map.put(:column, column)
    |> Map.put(:row, row)
    |> Map.put(:label, label)
  end

  defp new_unit("satyr", 1), do: %Unit{kind: "satyr", level: 1, live: 15, attack: 10, speed: 3}
  defp new_unit("satyr", 2), do: %Unit{kind: "satyr", level: 2, live: 35, attack: 15, speed: 3}
  defp new_unit("satyr", 3), do: %Unit{kind: "satyr", level: 3, live: 50, attack: 20, speed: 3}
  defp new_unit("golem", 1), do: %Unit{kind: "golem", level: 1, live: 40, attack: 5, speed: 1}
  defp new_unit("golem", 2), do: %Unit{kind: "golem", level: 2, live: 90, attack: 10, speed: 1}
  defp new_unit("golem", 3), do: %Unit{kind: "golem", level: 3, live: 140, attack: 15, speed: 1}
  defp new_unit("minotaur", 1), do: %Unit{kind: "minotaur", level: 1, live: 30, attack: 25, speed: 2}
  defp new_unit("minotaur", 2), do: %Unit{kind: "minotaur", level: 2, live: 70, attack: 50, speed: 2}
  defp new_unit("minotaur", 3), do: %Unit{kind: "minotaur", level: 3, live: 110, attack: 80, speed: 2}
  defp new_unit("wraith", 1), do: %Unit{kind: "wraith", level: 1, live: 35, attack: 35, speed: 1}
  defp new_unit("wraith", 2), do: %Unit{kind: "wraith", level: 2, live: 80, attack: 80, speed: 1}
  defp new_unit("wraith", 3), do: %Unit{kind: "wraith", level: 3, live: 150, attack: 150, speed: 1}
end
