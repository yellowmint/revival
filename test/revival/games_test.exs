defmodule Revival.GamesTest do
  use Revival.DataCase

  alias Revival.Games

  describe "plays" do
    alias Revival.Games.{Board, Field, Player}

    test "create_play/1 creates fresh play" do
      play = Games.create_play(:classic)

      assert play.mode == "classic"
      assert play.round == 1


      row = Enum.map(1..10, fn _ -> %Field{unit: nil} end)
      assert play.board == %Board{
          columns: 10,
          rows: 10,
          fields: Enum.map(1..10, fn _ -> row end)
        }

      assert play.players == [
          %Player{id: nil, name: nil, rank: nil},
          %Player{id: nil, name: nil, rank: nil}
        ]

    end

    test "create_play/1 creates plays with unique ids" do
      play1 = Games.create_play(:classic)
      play2 = Games.create_play(:classic)
      refute play1.id == play2.id
    end
  end
end
