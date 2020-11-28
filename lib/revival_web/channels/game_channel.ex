defmodule RevivalWeb.GameChannel do
  use Phoenix.Channel
  alias Revival.Games

  def join("game:" <> id, _params, socket) do
    case Games.get_play(id) do
      nil -> {:error, %{reason: "game not found"}}
      game -> {:ok, game.board, assign(socket, :id, game.id)}
    end
  end
end
