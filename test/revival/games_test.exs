defmodule Revival.GamesTest do
  use Revival.DataCase, async: true
  doctest Revival.Games

  alias Revival.Games

  describe "plays" do
    alias Revival.Games.{Board, Shop, Wallet, Move, Unit}
    alias Revival.Games.Shop.Good
    alias Revival.{AccountsFactory, GamesFactory}

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
      user = AccountsFactory.insert(:user, name: "Tom")
      player = Games.get_player(user.id, nil, "")

      assert player.id != nil
      assert player.user_id == user.id
      assert player.name == "Tom"
      assert player.rank == 0
    end

    test "join_play/2 adds player to play" do
      play = GamesFactory.insert(:play)
      player = GamesFactory.build(:anonymous_player)

      {:ok, game} = Games.join_play(play.id, player)

      assert Enum.count(game.players) == 1
    end

    test "join_play/2 refutes to join the same player twice" do
      play = GamesFactory.insert(:play)
      player = GamesFactory.build(:anonymous_player)

      {:ok, play} = Games.join_play(play.id, player)
      {:error, changeset} = Games.join_play(play.id, player)

      assert Enum.count(play.players) == 1
      assert changeset.errors == [players: {"list contains duplication", []}]
    end

    test "warm_up!/2 raises when warming up is not possible" do
      play = GamesFactory.insert(:play)

      assert_raise RuntimeError, "Warm up not possible", fn ->
        Games.warm_up!(play, fn _ -> nil end)
      end
    end

    test "warm_up!/2 starts warming up phase" do
      play = GamesFactory.insert(:play_with_players)
      play = Games.warm_up!(play, fn _ -> nil end)

      assert play.status == "warming_up"
      assert play.round == 0
      assert play.started_at
      assert play.timer_pid
      assert play.shop == %Shop{
               goods: [
                 %Good{kind: "satyr", level: 1, count: 5, price: %{money: 15, mana: 0}},
                 %Good{kind: "golem", level: 1, count: 5, price: %{money: 20, mana: 0}},
               ]
             }
      assert Enum.count(play.board.revival_spots) == 2
      Enum.each(play.players, fn player -> assert player.label end)
      Enum.each(play.players, fn player -> assert player.wallet == %Wallet{money: 50, mana: 10} end)
    end

    test "timeout/1 in warming_up status starts playing phase" do
      play = GamesFactory.insert(:play_with_players)
      play = Games.warm_up!(play, fn _ -> nil end)

      {:next, play} = Games.timeout(play.id)

      assert play.status == "playing"
      assert play.round == 1
      assert play.next_move
      assert play.next_move_deadline
    end

    test "timeout/1 in playing status finishes play" do
      play = GamesFactory.build(:started_play)
      {:stop, play} = Games.timeout(play.id)

      assert play.status == "finished"
      assert play.round == 1
      assert play.winner == "draw"
      assert play.finished_at
    end

    test "end_round/3 creates next round" do
      play = GamesFactory.build(:started_play)
      current_player = Move.get_player_of_current_round(play)
      play = Games.end_round(play.id, current_player.id, [])

      assert play.round == 2
      assert play.next_move != current_player.label
    end

    test "end_round/3 raises when wrong player tires to make move" do
      play = GamesFactory.build(:started_play)
      opponent = Move.get_opponent_of_current_round(play)

      assert_raise RuntimeError, "wrong player move", fn ->
        Games.end_round(play.id, opponent.id, [])
      end
    end

    test "end_round/3 handles moves" do
      play = GamesFactory.build(:started_play) |> ensure_blue_player_round
      player = Move.get_player_of_current_round(play)
      moves = [
        %{"type" => "place_unit", "position" => %{"column" => 8, "row" => 1}, "unit" => %{"kind" => "satyr", "level" => 1}}
      ]

      play = Games.end_round(play.id, player.id, moves)
      player = Move.get_opponent_of_current_round(play)

      assert player.wallet.money == 60 # 50 (base) - 15 (satyr) + 10 (round bound) + 15 (time bonus)
      assert play.board.units == [
               %Unit{kind: "satyr", level: 1, column: 8, row: 4, label: player.label, live: 15, attack: 10, speed: 3}
             ]
    end

    def ensure_blue_player_round(%{next_move: "blue"} = play), do: play
    def ensure_blue_player_round(%{next_move: "red"} = play) do
      player = Move.get_player_of_current_round(play)
      Games.end_round(play.id, player.id, [])
    end
  end
end
