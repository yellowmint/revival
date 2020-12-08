defmodule Revival.Games.Move do
  alias Revival.Games.{Shop, Wallet, Player, Unit, Board}

  def ensure_correct_player_move!(play, player_id) do
    current_player = get_player_of_current_round(play)

    if player_id == current_player.id,
      do: play,
      else: raise("wrong player move")
  end

  def get_player_of_current_round(play),
    do: Enum.find(play.players, fn x -> x.label == play.next_move end)

  def get_opponent_of_current_round(play),
    do: Enum.find(play.players, fn x -> x.label != play.next_move end)

  def next_move_changes(play, moves) do
    play
    |> handle_player_moves(moves)
    |> move_units_on_board()
    |> check_winner()
    |> supply_wallets()
    |> supply_shop()
    |> remove_corpses_from_board()
    |> Map.put(:round, play.round + 1)
    |> Map.put(:next_move, Player.opponent_for(play.next_move))
    |> Map.put(:next_move_deadline, next_round_deadline(play.mode))
    |> Map.from_struct()
  end

  defp handle_player_moves(play, moves), do: Enum.reduce(moves, play, &handle_move/2)

  defp handle_move(%{"type" => "place_unit"} = move, play) do
    %{
      "unit" => %{"kind" => kind, "level" => level},
      "position" => %{"column" => column, "row" => row}
    } = move

    {shop, good} = Shop.buy_unit(play.shop, %{kind: kind, level: level})

    player =
      play
      |> get_player_of_current_round()
      |> Player.spend!(good.price)

    unit = Unit.new(good, %{column: column, row: row}, player.label)
    board = Board.place_unit!(play.board, unit)

    play
    |> Map.put(:shop, shop)
    |> Map.put(:board, board)
    |> Map.put(:players, Player.update_player_in_list(play.players, player))
  end

  defp move_units_on_board(%{board: board, next_move: next_move} = play) do
    {board, base_damage} = Board.next_round(board, next_move)

    opponent =
      play
      |> get_opponent_of_current_round()
      |> Map.update!(:live, fn x -> x - base_damage end)

    play
    |> Map.put(:board, board)
    |> Map.put(:players, Player.update_player_in_list(play.players, opponent))
  end

  defp check_winner(play) do
    case Player.get_dead_player(play.players) do
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

    player = get_player_of_current_round(play)

    wallet =
      player.wallet
      |> Wallet.supply(round_bonus(play.round))
      |> Wallet.supply(time_bonus(play.next_move_deadline))

    players = Player.update_player_in_list(players, %{player | wallet: wallet})
    %{play | players: players}
  end

  defp corpse_bonus(player, corpses) do
    wallet =
      corpses
      |> Enum.filter(fn corpse -> corpse.label != player.label end)
      |> Enum.reduce(player.wallet, &sell_corpse/2)

    %{player | wallet: wallet}
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

  defp supply_shop(%{shop: shop} = play) do
    corpses = Board.get_corpses(play.board)
    shop = Shop.supply_shop(shop, corpses, play.round)

    %{play | shop: shop}
  end

  defp remove_corpses_from_board(%{board: board} = play) do
    board = Board.remove_corpses(board)
    %{play | board: board}
  end

  def next_round_deadline(mode) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(round_time(mode))
  end

  def round_time("classic"), do: 15
end
