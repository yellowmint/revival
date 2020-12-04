defmodule RevivalWeb.PlayChannel do
  use Phoenix.Channel
  alias Revival.Games

  def join("play:" <> id, _params, socket) do
    case Games.get_play(id) do
      nil -> {:error, %{reason: "game not found"}}
      play ->
        resp = %{play: Games.client_encode(play), player_id: socket.assigns.player_id}
        {:ok, resp, assign(socket, :play_id, play.id)}
    end
  end

  def handle_in("join_play", %{"name" => name}, socket) do
    %{play_id: play_id, user_id: user_id, player_id: player_id} = socket.assigns
    player = Games.get_player(user_id, player_id, name)

    case Games.join_play(play_id, player) do
      {:ok, play} ->
        auto_warm_up(play, socket)
        |> play_update(socket)
        {:noreply, socket}

      {:error, _reason} -> {:reply, :error, socket}
    end
  end

  def handle_in("end_round", %{"moves" => moves}, socket) do
    %{play_id: play_id, player_id: player_id} = socket.assigns

    Games.end_round(play_id, player_id, moves)
    {:noreply, socket}
  end

  defp auto_warm_up(play, socket) do
    if Games.can_warm_up?(play) do
      Games.warm_up!(play, fn (play) -> play_update(play, socket) end)
    else
      play
    end
  end

  defp play_update(play, socket) do
    broadcast!(socket, "play_update", Games.client_encode(play))
  end
end
