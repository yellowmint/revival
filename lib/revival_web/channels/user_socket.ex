defmodule RevivalWeb.UserSocket do
  use Phoenix.Socket

  channel "game:*", RevivalWeb.GameChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user auth", token, max_age: 86400) do
      {:ok, user_id} ->
        socket =
          socket
          |> assign(:user_id, user_id)
          |> assign(:anonymous_id, nil)

        {:ok, socket}
      {:error, _reason} -> {:error, "invalid token"}
    end
  end

  @impl true
  def connect(_params, socket, _connect_info) do
    socket =
      socket
      |> assign(:user_id, nil)
      |> assign(:anonymous_id, Ecto.UUID.generate())

    {:ok, socket}
  end

  @impl true
  def id(%{assigns: %{user_id: user_id}}), do: "user_socket:#{user_id}"

  @impl true
  def id(_socket), do: nil
end
