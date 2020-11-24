defmodule RevivalWeb.Plugs.AuthRequired do
  import Plug.Conn
  alias RevivalWeb.Router.Helpers, as: Routes

  def init(options), do: options

  def call(conn, _opts) do
    case conn.assigns.user_id do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: Routes.session_path(conn, :new))
        |> halt()
      user_id ->
        assign(conn, :current_user, Revival.Accounts.get_user!(user_id))
    end
  end
end
