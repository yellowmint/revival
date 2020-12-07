defmodule Revival.Games.Shop do
  alias Revival.Games.Shop

  @derive Jason.Encoder
  defstruct [:goods]

  defmodule Good do
    @derive Jason.Encoder
    defstruct [:kind, :level, :count, :price]
  end

  def new_shop("classic") do
    %Shop{
      goods: [
        new_good("satyr", 1) |> Map.put(:count, 5),
        new_good("golem", 1) |> Map.put(:count, 5),
      ]
    }
  end

  defp new_good("satyr", 1), do: %Good{kind: "satyr", level: 1, price: %{money: 15, mana: 0}}
  defp new_good("satyr", 2), do: %Good{kind: "satyr", level: 2, price: %{money: 35, mana: 0}}
  defp new_good("satyr", 3), do: %Good{kind: "satyr", level: 3, price: %{money: 70, mana: 0}}
  defp new_good("golem", 1), do: %Good{kind: "golem", level: 1, price: %{money: 20, mana: 0}}
  defp new_good("golem", 2), do: %Good{kind: "golem", level: 2, price: %{money: 45, mana: 0}}
  defp new_good("golem", 3), do: %Good{kind: "golem", level: 3, price: %{money: 90, mana: 0}}
  defp new_good("minotaur", 1), do: %Good{kind: "minotaur", level: 1, price: %{money: 30, mana: 5}}
  defp new_good("minotaur", 2), do: %Good{kind: "minotaur", level: 2, price: %{money: 70, mana: 15}}
  defp new_good("minotaur", 3), do: %Good{kind: "minotaur", level: 3, price: %{money: 140, mana: 35}}
  defp new_good("wraith", 1), do: %Good{kind: "wraith", level: 1, price: %{money: 80, mana: 20}}
  defp new_good("wraith", 2), do: %Good{kind: "wraith", level: 2, price: %{money: 150, mana: 50}}
  defp new_good("wraith", 3), do: %Good{kind: "wraith", level: 3, price: %{money: 300, mana: 80}}

  def corpse_price(corpse) do
    good = new_good(corpse.kind, corpse.level)
    %{money: :math.floor(good.price.money / 3), mana: good.level}
  end

  def buy_unit(shop, kind, level) do
    good_idx = Enum.find_index(shop.goods, fn x -> x.kind == kind && x.level == level end)
    good = Enum.fetch!(shop.goods, good_idx)

    goods =
      List.replace_at(shop.goods, good_idx, Map.put(good, :count, good.count - 1))
      |> Enum.filter(fn x -> x.count > 0 end)

    shop = Map.put(shop, :goods, goods)
    {shop, good}
  end
end
