defmodule Revival.GamesTest do
  use Revival.DataCase

  alias Revival.Games

  describe "plays" do
    alias Revival.Games.{Play, Board, Field, Player}

    test "new_game/3 creates fresh play" do
      play = Games.new_game(:classic, nil, nil)
      play = Map.put(play, :id, nil)

      column = Enum.map(1..10, fn _ -> %Field{unit: nil} end)

      assert play == %Play{
               id: nil,
               mode: :classic,
               round: 1,
               board: %Board{
                 columns: 10,
                 rows: 10,
                 fields: Enum.map(1..10, fn _ -> column end)
               },
               players: [
                 %Player{id: nil, name: nil, rank: nil},
                 %Player{id: nil, name: nil, rank: nil}
               ]
             }
    end

    test "new_game/3 creates plays with unique ids" do
      play1 = Games.new_game(:classic, nil, nil)
      play2 = Games.new_game(:classic, nil, nil)
      refute play1.id == play2.id
    end
  end
end
