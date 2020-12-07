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
        %Good{kind: "satyr", level: 1, count: 5, price: %{money: 15, mana: 0}},
        %Good{kind: "golem", level: 1, count: 5, price: %{money: 20, mana: 0}}
      ]
    }
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
