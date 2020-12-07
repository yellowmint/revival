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

  def withdraw!(wallet, amount) do
    wallet
    |> Map.put(:money, wallet.money - amount.money)
    |> Map.put(:mana, wallet.mana - amount.mana)
    |> ensure_founds!
  end

  defp ensure_founds!(wallet) do
    if wallet.money < 0, do: raise "not enough money for purchase"
    if wallet.mana < 0, do: raise "not enough mana for purchase"
    wallet
  end

  def supply(wallet, amount) do
    wallet
    |> Map.put(:money, wallet.money + amount.money)
    |> Map.put(:mana, wallet.mana + amount.mana)
  end
end
