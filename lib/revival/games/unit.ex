defmodule Revival.Games.Unit do
  @derive Jason.Encoder
  defstruct [:column, :row, :kind, :live]
end
