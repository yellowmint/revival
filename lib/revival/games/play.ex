defmodule Revival.Games.Play do
  alias Ecto.UUID
  alias Revival.Games.{Play, Board, Player}

  defstruct [:id, :mode, :round, :board, :players]

  def new_play(:classic, player1_id, player2_id) do
    board = Board.new_board(10, 10)
    players = [%Player{id: player1_id}, %Player{id: player2_id}]

    %Play{id: UUID.generate(), mode: :classic, round: 1, board: board, players: players}
  end
end
