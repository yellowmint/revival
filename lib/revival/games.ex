defmodule Revival.Games do
  @moduledoc """
  Provides functions to create new game and play it.
  """
  import Ecto.Query, warn: false
  alias Revival.Repo
  alias Revival.Games.{Play, Player}

  def create_play(mode) do
    Play.new_play(mode)
    |> Play.changeset()
    |> Repo.insert!()
  end

  def get_play(id), do: Repo.get(Play, id)
  def get_play!(id), do: Repo.get!(Play, id)

  def get_player(id, name) do
    Player.get_player(id, name)
  end

  def join(id, player) do
    play = get_play!(id)

    Play.changeset(play, %{players: play.players ++ [player]})
    |> Repo.update()
  end
end
