defmodule RevivalWeb.GameController do
  use RevivalWeb, :controller

  alias Revival.Games

  def create(conn, _params) do
    play = Games.create_play(:classic)
    redirect(conn, to: Routes.game_path(conn, :show, play))
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
