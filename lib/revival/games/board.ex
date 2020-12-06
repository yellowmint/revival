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
    %{column: Enum.random(2..(columns - 2)), row: revival_line(rows, label), label: label}
  end

  defp revival_line(rows, "blue"), do: round(rows / 4)
  defp revival_line(rows, "red"), do: rows - revival_line(rows, "blue") + 1

  def place_unit(board, unit) do
    if get_units(board.units, [unit]) != [], do: raise "another unit already in field"

    board
    |> Map.put(:units, board.units ++ [unit])
  end

  defp get_units(units, fields) do
    Enum.filter(units, fn unit ->
      Enum.find_index(fields, fn field ->
        unit.column == field.column and unit.row == field.row
      end)
    end)
  end
end
