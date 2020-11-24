defmodule RevivalWeb.Plugs.RetrieveUser do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    assign(conn, :user_id, get_session(conn, :user_id))
  end
end
