defmodule Revival.Games.Move do
  alias Revival.Games.Player

  def ensure_correct_player_move!(play, player_id) do
    current_player = get_player_of_current_round(play)
    if player_id == current_player.id, do: play,
                                       else: raise "wrong player move"
  end

  defp get_player_of_current_round(play) do
    Enum.find(play.players, fn x -> x.label == play.next_move end)
  end

  def next_move_changes(play) do
    %{}
    |> Map.put(:round, play.round + 1)
    |> Map.put(:next_move, Player.opponent_for(play.next_move))
    |> Map.put(:next_move_deadline, next_round_deadline(play.mode))
  end

  def round_time("classic"), do: 10

  def next_round_deadline(mode) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(round_time(mode))
  end
end
