defmodule Revival.Games.Board do
  alias Revival.Games.{Board}

  @derive Jason.Encoder
  defstruct [:columns, :rows, :units]

  def new_board(columns, rows) do
    %Board{columns: columns, rows: rows, units: []}
  end
end
