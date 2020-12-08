defmodule Revival.Games.Shop do
  alias Revival.Games.{Shop, Board}

  @derive Jason.Encoder
  defstruct [:goods]

  defmodule Good do
    @derive Jason.Encoder
    defstruct [:kind, :level, :count, :price]
  end

  defp good_type(%{kind: "satyr", level: 1}),
    do: %Good{kind: "satyr", level: 1, price: %{money: 15, mana: 0}}

  defp good_type(%{kind: "satyr", level: 2}),
    do: %Good{kind: "satyr", level: 2, price: %{money: 35, mana: 0}}

  defp good_type(%{kind: "satyr", level: 3}),
    do: %Good{kind: "satyr", level: 3, price: %{money: 70, mana: 0}}

  defp good_type(%{kind: "golem", level: 1}),
    do: %Good{kind: "golem", level: 1, price: %{money: 20, mana: 0}}

  defp good_type(%{kind: "golem", level: 2}),
    do: %Good{kind: "golem", level: 2, price: %{money: 45, mana: 0}}

  defp good_type(%{kind: "golem", level: 3}),
    do: %Good{kind: "golem", level: 3, price: %{money: 90, mana: 0}}

  defp good_type(%{kind: "minotaur", level: 1}),
    do: %Good{kind: "minotaur", level: 1, price: %{money: 30, mana: 2}}

  defp good_type(%{kind: "minotaur", level: 2}),
    do: %Good{kind: "minotaur", level: 2, price: %{money: 70, mana: 5}}

  defp good_type(%{kind: "minotaur", level: 3}),
    do: %Good{kind: "minotaur", level: 3, price: %{money: 140, mana: 10}}

  defp good_type(%{kind: "wraith", level: 1}),
    do: %Good{kind: "wraith", level: 1, price: %{money: 80, mana: 6}}

  defp good_type(%{kind: "wraith", level: 2}),
    do: %Good{kind: "wraith", level: 2, price: %{money: 150, mana: 15}}

  defp good_type(%{kind: "wraith", level: 3}),
    do: %Good{kind: "wraith", level: 3, price: %{money: 300, mana: 35}}

  defp new_good(type, count) do
    good_type(type)
    |> Map.put(:count, count)
  end

  def new_shop("classic") do
    %Shop{
      goods: [
        new_good(%{kind: "satyr", level: 1}, 5),
        new_good(%{kind: "golem", level: 1}, 5)
      ]
    }
  end

  def buy_unit(%{goods: goods} = shop, good_type) do
    good_idx = Enum.find_index(goods, &equal_kind_and_level(&1, good_type))

    good =
      goods
      |> Enum.fetch!(good_idx)
      |> Map.update!(:count, fn x -> x - 1 end)

    goods =
      goods
      |> List.replace_at(good_idx, good)
      |> Enum.filter(fn x -> x.count > 0 end)

    {%{shop | goods: goods}, good}
  end

  defp equal_kind_and_level(%{kind: kind1, level: level1}, %{kind: kind2, level: level2}) do
    kind1 == kind2 && level1 == level2
  end

  def corpse_price(corpse) do
    good = new_good(corpse, 1)
    %{money: :math.floor(good.price.money / 4), mana: good.level}
  end

  def supply_shop(play) do
    shop =
      Board.get_corpses(play.board)
      |> Enum.reduce(play.shop, &corpse_to_good/2)
      |> round_supply(play.round)

    Map.put(play, :shop, sort_assortment(shop))
  end

  defp corpse_to_good(corpse, shop) do
    cond do
      corpse.live < -20 ->
        shop

      true ->
        good =
          new_good(corpse.kind, corpse.level)
          |> Map.put(:count, 1)

        add_to_shop(shop, good)
    end
  end

  defp add_to_shop(shop, good) do
    goods =
      case Enum.find_index(shop.goods, &equal_kind_and_level(&1, good)) do
        nil ->
          shop.goods ++ [good]

        idx ->
          List.update_at(shop.goods, idx, fn x -> Map.put(x, :count, x.count + good.count) end)
      end

    Map.put(shop, :goods, goods)
  end

  defp round_supply(shop, round) do
    kind = Enum.random(["satyr", "golem", "minotaur", "wraith"])

    level =
      cond do
        round < 10 -> 1
        round < 30 -> Enum.random([1, 2])
        true -> Enum.random([1, 2, 3])
      end

    add_to_shop(shop, new_good(%{kind: kind, level: level}, 1))
  end

  defp sort_assortment(%{goods: goods} = shop) do
    goods = Enum.sort(goods, fn a, b -> a.price.money <= b.price.money end)
    %{shop | goods: goods}
  end
end
