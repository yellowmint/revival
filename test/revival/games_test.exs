defmodule Revival.GamesTest do
  use Revival.DataCase

  alias Revival.Games

  describe "plays" do
    alias Revival.Games.Board

    def player_fixture(attrs \\ %{}) do
      attrs = Enum.into(attrs, %{user_id: nil, anonymous_id: Ecto.UUID.generate(), name: "Mike"})
      Games.get_player(attrs.user_id, attrs.anonymous_id, attrs.name)
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "some@email.com", name: "some name", password: "some password"})
        |> Revival.Accounts.create_user()

      user
    end

    test "create_play/1 creates fresh play" do
      play = Games.create_play(:classic)

      assert play.mode == "classic"
      assert play.status == "joining"
      assert play.board == %Board{
               columns: 10,
               rows: 10,
               units: [],
               revival_spots: []
             }
      assert play.players == []
    end

    test "create_play/1 creates plays with unique ids" do
      play1 = Games.create_play(:classic)
      play2 = Games.create_play(:classic)

      refute play1.id == play2.id
    end

    test "get_player/3 returns anonymous player" do
      anonymous_id = Ecto.UUID.generate()
      player = Games.get_player(nil, anonymous_id, "Mike")

      assert player.id == anonymous_id
      assert player.user_id == nil
      assert player.name == "Mike"
      assert player.rank == 0
    end

    test "get_player/3 returns registered player" do
      user = user_fixture(name: "Tom")
      player = Games.get_player(user.id, nil, "")

      assert player.id != nil
      assert player.user_id == user.id
      assert player.name == "Tom"
      assert player.rank == 0
    end

    test "join_play/2 adds player to play" do
      play = Games.create_play(:classic)
      player = player_fixture()

      {:ok, game} = Games.join_play(play.id, player)

      assert Enum.count(game.players) == 1
    end

    test "join_play/2 refute to join the same player twice" do
      play = Games.create_play(:classic)
      player = player_fixture()

      {:ok, game} = Games.join_play(play.id, player)
      {:error, changeset} = Games.join_play(play.id, player)

      assert Enum.count(game.players) == 1
      assert changeset.errors == [players: {"list contains duplication", []}]
    end
  end
end
