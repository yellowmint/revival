defmodule Revival.Games do
  @moduledoc """
  Game context
  """

  alias Revival.Games.Play

  def new_game(mode, player1_id, player2_id) do
    Play.new_play(mode, player1_id, player2_id)
  end
end
