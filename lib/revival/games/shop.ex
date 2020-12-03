defmodule Revival.Games.Shop do
  alias Revival.Games.Shop

  @derive Jason.Encoder
  defstruct [:goods]

  defmodule Good do
    @derive Jason.Encoder
    defstruct [:kind, :level, :count]
  end

  def new_shop("classic") do
    %Shop{
      goods: [
        %Good{kind: "golem", level: 1, count: 5},
        %Good{kind: "minotaur", level: 1, count: 5}
      ]
    }
  end
end
