defmodule Revival.Games.Board do
  alias Revival.Games.{Board, Field}

  defstruct [:columns, :rows, :fields]

  def new_board(columns, rows) do
    fields =
      Enum.map(1..columns, fn _ ->
        Enum.map(1..rows, fn _ -> %Field{} end)
      end)

    %Board{columns: columns, rows: rows, fields: fields}
  end
end
