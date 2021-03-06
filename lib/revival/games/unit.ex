defmodule Revival.Games.Unit do
  alias Revival.Games.Unit

  @derive Jason.Encoder
  defstruct [:column, :row, :kind, :level, :live, :attack, :speed, :label]

  defp new_unit(%{kind: "satyr", level: 1}),
    do: %Unit{kind: "satyr", level: 1, live: 15, attack: 10, speed: 3}

  defp new_unit(%{kind: "satyr", level: 2}),
    do: %Unit{kind: "satyr", level: 2, live: 35, attack: 15, speed: 3}

  defp new_unit(%{kind: "satyr", level: 3}),
    do: %Unit{kind: "satyr", level: 3, live: 50, attack: 20, speed: 3}

  defp new_unit(%{kind: "golem", level: 1}),
    do: %Unit{kind: "golem", level: 1, live: 40, attack: 5, speed: 1}

  defp new_unit(%{kind: "golem", level: 2}),
    do: %Unit{kind: "golem", level: 2, live: 90, attack: 10, speed: 1}

  defp new_unit(%{kind: "golem", level: 3}),
    do: %Unit{kind: "golem", level: 3, live: 140, attack: 15, speed: 1}

  defp new_unit(%{kind: "minotaur", level: 1}),
    do: %Unit{kind: "minotaur", level: 1, live: 30, attack: 25, speed: 2}

  defp new_unit(%{kind: "minotaur", level: 2}),
    do: %Unit{kind: "minotaur", level: 2, live: 70, attack: 50, speed: 2}

  defp new_unit(%{kind: "minotaur", level: 3}),
    do: %Unit{kind: "minotaur", level: 3, live: 110, attack: 80, speed: 2}

  defp new_unit(%{kind: "wraith", level: 1}),
    do: %Unit{kind: "wraith", level: 1, live: 35, attack: 35, speed: 1}

  defp new_unit(%{kind: "wraith", level: 2}),
    do: %Unit{kind: "wraith", level: 2, live: 80, attack: 80, speed: 1}

  defp new_unit(%{kind: "wraith", level: 3}),
    do: %Unit{kind: "wraith", level: 3, live: 150, attack: 150, speed: 1}

  def new(unit_type, %{column: column, row: row}, label) do
    new_unit(unit_type)
    |> Map.put(:column, column)
    |> Map.put(:row, row)
    |> Map.put(:label, label)
  end
end
