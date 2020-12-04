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
        %Good{kind: "satyr", level: 1, count: 5, price: 15},
        %Good{kind: "golem", level: 1, count: 5, price: 20}
      ]
    }
  end
end
