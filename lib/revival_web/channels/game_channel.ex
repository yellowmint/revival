defmodule RevivalWeb.GameChannel do
  use Phoenix.Channel
  alias Revival.Games

  def join("game:" <> id, _params, socket) do
    case Games.get_play(id) do
      nil -> {:error, %{reason: "game not found"}}
      game -> {:ok, game, assign(socket, :game_id, game.id)}
    end
  end

  def handle_in("join_game", %{"name" => name}, socket) do
    player = Games.get_player(socket.assigns.user_id, name)

    case Games.join(socket.assigns.game_id, player) do
      {:ok, _game} ->
        reply = {:ok, %{player_id: player.id}}
        socket = assign(socket, :player, player)
        {:reply, reply, socket}
      {:error, _reason} -> {:reply, :error, socket}
    end
  end
end
