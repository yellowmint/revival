defmodule Revival.AccountsTest do
  use Revival.DataCase, async: true

  alias Revival.Accounts

  describe "users" do
    alias Revival.Accounts.User
    alias Revival.AccountsFactory

    @valid_attrs %{email: "some@email.com", name: "some name", password: "some password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    test "get_user!/1 returns the user with given id" do
      user = AccountsFactory.insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_new_user/1 returns a user changeset" do
      user = AccountsFactory.insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_new_user(user)
    end
  end
end
