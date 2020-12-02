defmodule RevivalWeb.PlayerControllerTest do
  use RevivalWeb.ConnCase, async: true

  alias Revival.GamesFactory

  describe "index" do
    test "show players ranking", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index))
      assert html_response(conn, 200) =~ "Players ranking"
    end
  end

  describe "show player details" do
    test "renders form", %{conn: conn} do
      player = GamesFactory.insert(:registered_player)
      conn = get(conn, Routes.player_path(conn, :show, player))
      assert html_response(conn, 200) =~ "Player details"
    end
  end
end
