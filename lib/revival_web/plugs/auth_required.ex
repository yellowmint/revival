defmodule RevivalWeb.Plugs.AuthRequired do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, Revival.Accounts.get_user!(user_id))
    end
  end
end
