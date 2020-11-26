defmodule RevivalWeb.GameController do
  use RevivalWeb, :controller

  alias Revival.Games

  def create(conn, _params) do
    game = Games.new_game(:classic, nil, nil)

    conn
    |> put_flash(:info, "New game created")
    |> redirect(to: Routes.game_path(conn, :show, game))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id)
  end
end
