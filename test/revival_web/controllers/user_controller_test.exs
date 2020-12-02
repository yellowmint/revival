defmodule RevivalWeb.UserControllerTest do
  use RevivalWeb.ConnCase, async: true

  @create_attrs %{email: "some@email.com", name: "some name", password: "some password"}
  @invalid_attrs %{email: nil, name: nil, password: nil}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Registration"
    end
  end

  describe "create user" do
    test "redirects to main page when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Registration"
    end
  end
end
