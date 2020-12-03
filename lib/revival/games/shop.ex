defmodule Revival.Games.Shop do
  alias Revival.Games.Shop

  @derive Jason.Encoder
  defstruct [:minotaur_count, :witch_count]

  def new_show(:classic) do
    %Shop{
      minotaur_count: 10,
      witch_count: 5
    }
  end
end
