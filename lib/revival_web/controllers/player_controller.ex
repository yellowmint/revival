defmodule RevivalWeb.PlayerController do
  use RevivalWeb, :controller

  alias Revival.Games

  def index(conn, _params) do
    players = Games.ranking()
    render(conn, "index.html", players: players)
  end

  def show(conn, %{"id" => id}) do
    player = Games.get_player!(id)
    render(conn, "show.html", player: player)
  end
end
