defmodule Revival.Games.Unit do
  @derive Jason.Encoder
  defstruct [:column, :row, :kind, :level, :live, :label]
end
