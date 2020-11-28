defmodule Revival.Games do
  @moduledoc """
  Provides functions to create new game and play it.
  """
  import Ecto.Query, warn: false
  alias Revival.Repo
  alias Revival.Games.Play

  def create_play(mode) do
    Play.new_play(mode)
    |> Play.changeset()
    |> Repo.insert!()
  end

  def get_play(id), do: Repo.get(Play, id)
end
