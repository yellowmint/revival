defmodule Revival.Games.Player do
  @derive Jason.Encoder
  defstruct [:id, :name, :rank]
end
