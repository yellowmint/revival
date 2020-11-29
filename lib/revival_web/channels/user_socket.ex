defmodule RevivalWeb.UserSocket do
  use Phoenix.Socket

  channel "game:*", RevivalWeb.GameChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user auth", token, max_age: 86400) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} -> {:ok, assign(socket, :anonymous_id, Ecto.UUID.generate)}
    end
  end

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(%{assigns: %{user_id: user_id}}), do: "user_socket:#{user_id}"

  @impl true
  def id(_socket), do: nil
end
