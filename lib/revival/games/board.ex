defmodule Revival.Games.Board do
  alias Revival.Games.{Board, Move}

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

  def place_unit(board, unit, label) do
    if get_units_from_fields(board.units, [unit]) != [], do: raise "another unit already in field"
    if label == "blue" and unit.row != 1, do: raise "blue player must place units in first row"
    if label == "red" and unit.row != board.rows, do: raise "red player must place units in last row"

    board
    |> Map.put(:units, board.units ++ [unit])
  end

  defp get_units_from_fields(units, fields) do
    Enum.filter(units, fn unit -> Enum.find(fields, &equal_position(&1, unit)) end)
  end

  defp equal_position(field1, field2) do
    field1.column == field2.column and field1.row == field2.row
  end

  def next_round(play) do
    play
    |> attack_enemies_and_move_forward()
    |> attack_enemy_base()
  end

  defp attack_enemies_and_move_forward(play) do
    play.board.units
    |> Enum.filter(fn x -> x.label == play.next_move end)
    |> Enum.reduce(play, &unit_moves(&2, &1))
  end

  defp unit_moves(%{board: board} = play, unit) do
    unit_idx = Enum.find_index(board.units, &equal_position(&1, unit))

    units = Enum.reduce_while(1..unit.speed, board.units, fn _, units -> unit_move(units, unit_idx, board.rows) end)

    play
    |> Map.put(:board, Map.put(board, :units, units))
  end

  defp unit_move(units, unit_idx, rows) do
    unit = Enum.fetch!(units, unit_idx)

    case attack(units, unit, unit_idx) do
      {:fought, units} -> {:halt, units}
      :no_enemies -> forward(units, unit, unit_idx, rows)
    end
  end

  defp forward(units, unit, unit_idx, rows_limit) do
    case step_forward(unit, rows_limit) do
      :border -> {:halt, units}
      {:step, unit} -> {:cont, List.replace_at(units, unit_idx, unit)}
    end
  end

  defp step_forward(%{label: "blue"} = unit, rows_limit) do
    if unit_at_border(unit, rows_limit), do: :border,
                                         else: {:step, Map.put(unit, :row, unit.row + 1)}
  end

  defp step_forward(%{label: "red"} = unit, _) do
    if unit_at_border(unit, nil), do: :border,
                                  else: {:step, Map.put(unit, :row, unit.row - 1)}
  end

  defp unit_at_border(%{label: "blue"} = unit, rows_limit), do: unit.row == rows_limit
  defp unit_at_border(%{label: "red"} = unit, _), do: unit.row == 1

  defp attack(units, unit, unit_idx) do
    units =
      units
      |> get_enemies_to_attack(unit)
      |> Enum.shuffle()
      |> Enum.reduce_while(units, &attack_enemy_unit(&2, unit_idx, &1))

    veteran = Enum.fetch!(units, unit_idx)
    if unit.live != veteran.live, do: {:fought, units},
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
      %{column: unit.column, row: unit.row + 1},
    ]
  end

  defp fields_in_attack_range(%{label: "red"} = unit) do
    [
      %{column: unit.column - 1, row: unit.row},
      %{column: unit.column + 1, row: unit.row},
      %{column: unit.column, row: unit.row - 1},
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

  defp is_alive(%{live: live}), do: live > 0

  defp attack_enemy_base(play) do
    play.board.units
    |> Enum.filter(fn x -> x.label == play.next_move end)
    |> Enum.filter(&unit_at_border(&1, play.board.rows))
    |> Enum.filter(&is_alive/1)
    |> Enum.reduce(play, &unit_attack_base(&2, &1))
  end

  defp unit_attack_base(play, unit) do
    {opponent, opponent_idx} = Move.get_opponent_of_current_round(play)
    opponent = Map.put(opponent, :live, opponent.live - unit.attack)

    play
    |> Map.put(:players, List.replace_at(play.players, opponent_idx, opponent))
  end

  def remove_corpses(play) do
    units = Enum.filter(play.board.units, &is_alive/1)

    play
    |> Map.put(:board, Map.put(play.board, :units, units))
  end
end
