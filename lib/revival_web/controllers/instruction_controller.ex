defmodule RevivalWeb.InstructionController do
  use RevivalWeb, :controller

  def index(conn, _params),
    do: render(conn, "index.html")
end
