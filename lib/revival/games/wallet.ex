defmodule Revival.Games.Wallet do
  alias Revival.Games.Wallet

  @derive Jason.Encoder
  defstruct [:money, :mana]

  def new_wallet("classic") do
    %Wallet{
      money: 50,
      mana: 10
    }
  end
end
