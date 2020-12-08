defmodule Revival.Games.Board do
  alias Revival.Games.Board

  @derive Jason.Encoder
  defstruct [:columns, :rows, :units, :revival_spots]

  def new_board(columns, rows) do
    %Board{
      columns: columns,
      rows: rows,
      units: [],
      revival_spots: []
    }
  end

  def create_revival_spots(board) do
    revival_spots = [
      new_revival_spot(board.columns, board.rows, "blue"),
      new_revival_spot(board.columns, board.rows, "red")
    ]

    Map.put(board, :revival_spots, revival_spots)
  end

  defp new_revival_spot(columns, rows, label) do
    %{column: Enum.random(2..(columns - 2)), row: revival_line(rows, label)}
  end

  defp revival_line(rows, "blue"), do: round(rows / 4)
  defp revival_line(rows, "red"), do: rows - revival_line(rows, "blue") + 1

  def place_unit!(board, unit) do
    if get_units_from_fields(board.units, [unit]) != [],
      do: raise("another unit already in field")

    if unit.label == "blue" and unit.row != 1,
      do: raise("blue unit must be placed in first row")

    if unit.label == "red" and unit.row != board.rows,
      do: raise("red unit must be placed in last row")

    Map.put(board, :units, board.units ++ [unit])
  end

  defp get_units_from_fields(units, fields) do
    Enum.filter(units, fn unit -> Enum.find(fields, &equal_position(&1, unit)) end)
  end

  defp equal_position(field1, field2) do
    field1.column == field2.column and field1.row == field2.row
  end

  def next_round(board, move_label) do
    board = attack_enemies_and_move_forward(board, move_label)
    base_damage = attack_enemy_base(board, move_label)
    {board, base_damage}
  end

  defp attack_enemies_and_move_forward(%{units: units} = board, move_label) do
    units
    |> Enum.filter(fn x -> x.label == move_label end)
    |> Enum.reduce(board, &unit_moves/2)
  end

  defp unit_moves(unit, board) do
    unit_idx = Enum.find_index(board.units, &equal_position(&1, unit))

    units =
      1..unit.speed
      |> Enum.reduce_while(board.units, fn _, units -> unit_move(units, unit_idx, board.rows) end)

    %{board | units: units}
  end

  defp unit_move(units, unit_idx, rows) do
    unit = Enum.fetch!(units, unit_idx)

    case attack(units, unit, unit_idx) do
      {:fought, units} -> {:cont, units}
      :no_enemies -> forward(units, unit, unit_idx, rows)
    end
  end

  defp attack(units, unit, unit_idx) do
    units =
      units
      |> get_enemies_to_attack(unit)
      |> Enum.shuffle()
      |> Enum.reduce_while(units, &attack_enemy_unit(&2, unit_idx, &1))

    veteran = Enum.fetch!(units, unit_idx)

    if unit.live != veteran.live,
      do: {:fought, units},
      else: :no_enemies
  end

  defp get_enemies_to_attack(units, unit) do
    units
    |> Enum.filter(fn x -> x.label != unit.label end)
    |> Enum.filter(&is_alive/1)
    |> get_units_from_fields(fields_in_attack_range(unit))
  end

  defp fields_in_attack_range(%{label: "blue"} = unit) do
    [
      %{column: unit.column - 1, row: unit.row},
      %{column: unit.column + 1, row: unit.row},
      %{column: unit.column, row: unit.row + 1}
    ]
  end

  defp fields_in_attack_range(%{label: "red"} = unit) do
    [
      %{column: unit.column - 1, row: unit.row},
      %{column: unit.column + 1, row: unit.row},
      %{column: unit.column, row: unit.row - 1}
    ]
  end

  defp attack_enemy_unit(units, unit_idx, enemy) do
    unit = Enum.fetch!(units, unit_idx)
    enemy_idx = Enum.find_index(units, &equal_position(&1, enemy))

    {enemy, unit} = clash(enemy, unit)

    units =
      units
      |> List.replace_at(enemy_idx, enemy)
      |> List.replace_at(unit_idx, unit)

    if is_alive(unit), do: {:cont, units}, else: {:halt, units}
  end

  defp clash(unit1, unit2) do
    unit1 = Map.put(unit1, :live, unit1.live - unit2.attack)
    unit2 = Map.put(unit2, :live, unit2.live - unit1.attack)
    {unit1, unit2}
  end

  defp is_alive(unit), do: unit.live > 0

  defp forward(units, unit, unit_idx, rows_limit) do
    if unit_at_border(unit, rows_limit),
      do: {:halt, units},
      else: try_step_forward(units, unit, unit_idx)
  end

  defp unit_at_border(%{label: "blue"} = unit, rows_limit), do: unit.row == rows_limit
  defp unit_at_border(%{label: "red"} = unit, _), do: unit.row == 1

  defp try_step_forward(units, unit, unit_idx) do
    unit = step_forward(unit)

    case get_units_from_fields(units, [unit]) do
      [] -> {:cont, List.replace_at(units, unit_idx, unit)}
      _ -> {:halt, units}
    end
  end

  defp step_forward(%{label: "blue"} = unit), do: Map.put(unit, :row, unit.row + 1)
  defp step_forward(%{label: "red"} = unit), do: Map.put(unit, :row, unit.row - 1)

  defp attack_enemy_base(%{units: units} = board, move_label) do
    units
    |> Enum.filter(fn x -> x.label == move_label end)
    |> Enum.filter(&unit_at_border(&1, board.rows))
    |> Enum.filter(&is_alive/1)
    |> Enum.reduce(0, &(&1.attack + &2))
  end

  def upgrade_units_in_revival_spots(%{units: units, revival_spots: revival_spots} = board) do
    units =
      get_units_from_fields(units, revival_spots)
      |> Enum.reduce(units, &upgrade_unit/2)

    %{board | units: units}
  end

  defp upgrade_unit(unit, units) do
    unit_idx = Enum.find_index(units, &equal_position(&1, unit))

    unit =
      unit
      |> Map.put(:speed, unit.speed + 1)
      |> Map.put(:live, :math.floor(unit.live * 1.2))
      |> Map.put(:attack, :math.floor(unit.attack * 1.3))

    List.replace_at(units, unit_idx, unit)
  end

  def get_corpses(board) do
    Enum.reject(board.units, &is_alive/1)
  end

  def remove_corpses(%{units: units} = board) do
    units = Enum.filter(units, &is_alive/1)
    %{board | units: units}
  end
end
