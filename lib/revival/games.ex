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

  def get_play(id) do
    case Repo.get(Play, id) do
      {:ok, play} -> {:ok, play |> Play.unify_keys()}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def get_play!(id), do: Repo.get!(Play, id) |> Play.unify_keys()

  def get_player(user_id, anonymous_id, name), do: Player.get_player(user_id, anonymous_id, name)

  def join_play(id, player) do
    play = get_play!(id)

    play
    |> Play.changeset(%{players: play.players ++ [player]})
    |> Repo.update()
  end

  def can_warm_up?(play), do: Play.can_warm_up?(play)

  def warm_up!(play) do
    if !can_warm_up?(play), do: raise "Warm up not possible"

    play
    |> Play.changeset(Play.warm_up_play(play))
    |> Repo.update!()
  end
end
