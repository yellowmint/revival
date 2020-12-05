defmodule Revival.Games.Move do
  alias Revival.Games.{Shop, Wallet, Player}

  def ensure_correct_player_move!(play, player_id) do
    {current_player, _} = get_player_of_current_round(play)
    if player_id == current_player.id, do: play,
                                       else: raise "wrong player move"
  end

  def get_player_of_current_round(play) do
    player = Enum.find(play.players, fn x -> x.label == play.next_move end)
    idx = Enum.find_index(play.players, fn x -> x.id == player.id end)
    {player, idx}
  end

  def next_move_changes(play, moves) do
    handle_moves(play, moves)
    |> Map.put(:round, play.round + 1)
    |> Map.put(:next_move, Player.opponent_for(play.next_move))
    |> Map.put(:next_move_deadline, next_round_deadline(play.mode))
    |> Map.from_struct()
  end

  def next_round_deadline(mode) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(round_time(mode))
  end

  def round_time("classic"), do: 3600

  defp handle_moves(play, moves) do
    Enum.reduce(moves, play, &handle_move/2)
  end

  defp handle_move(%{"type" => "place_unit"} = move, play) do
    %{"unit" => %{"kind" => kind, "level" => level}, "position" => %{"column" => column, "row" => row}} = move
    {current_player, current_player_idx} = get_player_of_current_round(play)

    {shop, good} = Shop.buy_unit(play.shop, kind, level)

    wallet = Wallet.take_money_for_good!(current_player.wallet, good)
    current_player = Map.put(current_player, :wallet, wallet)

    play
    |> Map.put(:shop, shop)
    |> Map.put(:players, List.replace_at(play.players, current_player_idx, current_player))
  end
end
