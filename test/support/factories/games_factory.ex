defmodule Revival.GamesFactory do
  use ExMachina.Ecto, repo: Revival.Repo
  alias Revival.AccountsFactory
  alias Revival.Games
  alias Revival.Games.{Play, Player}

  def play_factory() do
    Play.new_play(:classic)
  end

  def play_with_players_factory() do
    build(:play)
    |> Map.put(:players, [build(:anonymous_player), build(:anonymous_player)])
  end

  def started_play_factory(_ \\ %{}) do
    play = insert(:play_with_players) |> Games.warm_up!(fn _ -> nil end)
    {:next, play} = Games.timeout(play.id)
    play
  end

  def anonymous_player_factory() do
    %Player{
      id: Ecto.UUID.generate(),
      user_id: nil,
      name: sequence(:player_name, ["Alice", "Tom"]),
      rank: 0
    }
  end

  def registered_player_factory(attrs) do
    user = Map.get(attrs, :user) || AccountsFactory.insert(:user)

    %Player{
      user_id: user.id,
      name: user.name,
      rank: 0
    }
    |> merge_attributes(attrs)
  end
end
