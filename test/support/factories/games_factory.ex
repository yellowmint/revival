defmodule Revival.GamesFactory do
  use ExMachina.Ecto, repo: Revival.Repo

  def play_factory() do
    Revival.Games.Play.new_play(:classic)
  end

  def play_with_players_factory() do
    build(:play)
    |> Map.put(:players, [build(:anonymous_player), build(:anonymous_player)])
  end

  def anonymous_player_factory() do
    %Revival.Games.Player{
      id: Ecto.UUID.generate(),
      user_id: nil,
      name: sequence(:player_name, ["Alice", "Tom"]),
      rank: 0
    }
  end

  def registered_player_factory(attrs) do
    user = Map.get(attrs, :user) || Revival.AccountsFactory.insert(:user)

    %Revival.Games.Player{
      user_id: user.id,
      name: user.name,
      rank: 0
    }
    |> merge_attributes(attrs)
  end
end
