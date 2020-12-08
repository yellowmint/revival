defmodule Revival.Games.Move do
  alias Revival.Games.{Shop, Wallet, Player, Unit, Board}

  def ensure_correct_player_move!(play, player_id) do
    {current_player, _} = get_player_of_current_round(play)

    if player_id == current_player.id,
      do: play,
      else: raise("wrong player move")
  end

  def get_player_of_current_round(play) do
    player = Enum.find(play.players, fn x -> x.label == play.next_move end)
    idx = Enum.find_index(play.players, fn x -> x.id == player.id end)
    {player, idx}
  end

  def get_opponent_of_current_round(play) do
    player = Enum.find(play.players, fn x -> x.label != play.next_move end)
    idx = Enum.find_index(play.players, fn x -> x.id == player.id end)
    {player, idx}
  end

  def next_move_changes(play, moves) do
    play
    |> handle_moves(moves)
    |> Board.next_round()
    |> check_winner()
    |> supply_wallets()
    |> Shop.supply_shop()
    |> Board.remove_corpses()
    |> revival_spots()
    |> Map.put(:round, play.round + 1)
    |> Map.put(:next_move, Player.opponent_for(play.next_move))
    |> Map.put(:next_move_deadline, next_round_deadline(play.mode))
    |> Map.from_struct()
  end

  defp handle_moves(play, moves), do: Enum.reduce(moves, play, &handle_move/2)

  defp handle_move(%{"type" => "place_unit"} = move, play) do
    %{
      "unit" => %{"kind" => kind, "level" => level},
      "position" => %{"column" => column, "row" => row}
    } = move

    {shop, good} = Shop.buy_unit(play.shop, %{kind: kind, level: level})

    {current_player, current_player_idx} = get_player_of_current_round(play)
    current_player = Player.spend!(current_player, good.price)
    players = List.replace_at(play.players, current_player_idx, current_player)

    unit = Unit.new(good, %{column: column, row: row}, current_player.label)
    board = Board.place_unit!(play.board, unit, current_player.label)

    play
    |> Map.put(:shop, shop)
    |> Map.put(:board, board)
    |> Map.put(:players, players)
  end

  defp check_winner(play) do
    case Enum.find(play.players, fn player -> player.live <= 0 end) do
      nil -> play
      looser -> handle_win(play, looser)
    end
  end

  defp handle_win(play, looser) do
    play
    |> Map.put(:status, "finished")
    |> Map.put(:finished_at, NaiveDateTime.utc_now())
    |> Map.put(:winner, Player.opponent_for(looser.label))
  end

  defp supply_wallets(play) do
    corpses = Board.get_corpses(play.board)
    players = Enum.map(play.players, &corpse_bonus(&1, corpses))

    {_, player_idx} = get_player_of_current_round(play)
    current_round_player = Enum.fetch!(players, player_idx)

    wallet =
      current_round_player.wallet
      |> Wallet.supply(round_bonus(play.round))
      |> Wallet.supply(time_bonus(play.next_move_deadline))

    players = List.replace_at(players, player_idx, Map.put(current_round_player, :wallet, wallet))
    Map.put(play, :players, players)
  end

  defp corpse_bonus(player, corpses) do
    wallet =
      corpses
      |> Enum.filter(fn corpse -> corpse.label != player.label end)
      |> Enum.reduce(player.wallet, &sell_corpse/2)

    Map.put(player, :wallet, wallet)
  end

  defp sell_corpse(corpse, wallet) do
    price = Shop.corpse_price(corpse)
    Wallet.supply(wallet, price)
  end

  defp round_bonus(round) do
    cond do
      round < 10 -> %{money: 10, mana: 0}
      round < 30 -> %{money: 20, mana: 0}
      round < 50 -> %{money: 30, mana: 0}
      true -> %{money: 50, mana: 0}
    end
  end

  defp time_bonus(deadline) do
    diff = NaiveDateTime.diff(deadline, NaiveDateTime.utc_now())

    cond do
      diff > 5 -> %{money: 15, mana: 0}
      diff > 4 -> %{money: 10, mana: 0}
      diff > 3 -> %{money: 5, mana: 0}
      true -> %{money: 0, mana: 0}
    end
  end

  def revival_spots(%{board: board} = play) do
    board = Board.upgrade_units_in_revival_spots(board)
    %{play | board: board}
  end

  def next_round_deadline(mode) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(round_time(mode))
  end

  def round_time("classic"), do: 3600
end
