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
    %{game_id: game_id, user_id: user_id, anonymous_id: anonymous_id} = socket.assigns
    player = Games.get_player(user_id, anonymous_id, name)

    case Games.join_play(game_id, player) do
      {:ok, game} ->
        game = auto_warm_up(game)
        broadcast!(socket, "game_update", game)
        {:reply, {:ok, player.id}, assign(socket, :player, player)}

      {:error, _reason} ->
        {:reply, :error, socket}
    end
  end

  defp auto_warm_up(game) do
    if Games.can_warm_up?(game), do: Games.warm_up!(game),
                                 else: game
  end
end
