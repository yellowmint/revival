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

  def withdraw!(wallet, %{money: money, mana: mana}) do
    wallet
    |> Map.put(:money, wallet.money - money)
    |> Map.put(:mana, wallet.mana - mana)
    |> ensure_founds!
  end

  defp ensure_founds!(%{money: money, mana: mana} = wallet) do
    if money < 0, do: raise("not enough money for purchase")
    if mana < 0, do: raise("not enough mana for purchase")
    wallet
  end

  def supply(wallet, %{money: money, mana: mana}) do
    wallet
    |> Map.put(:money, wallet.money + money)
    |> Map.put(:mana, wallet.mana + mana)
  end
end
