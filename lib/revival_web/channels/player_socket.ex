defmodule RevivalWeb.PlayerSocket do
  use Phoenix.Socket

  channel "play:*", RevivalWeb.PlayChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user auth", token, max_age: 86400) do
      {:ok, user_id} ->
        %{id: player_id} = Games.get_player(user_id, nil, "")
        socket =
          socket
          |> assign(:user_id, user_id)
          |> assign(:player_id, player_id)
        {:ok, socket}

      {:error, _reason} -> {:error, "invalid token"}
    end
  end

  @impl true
  def connect(_params, socket, _connect_info) do
    socket =
      socket
      |> assign(:user_id, nil)
      |> assign(:player_id, Ecto.UUID.generate())

    {:ok, socket}
  end

  @impl true
  def id(%{assigns: %{player_id: player_id}}), do: "player_socket:#{player_id}"
end
