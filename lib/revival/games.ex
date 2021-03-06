defmodule Revival.Games do
  @moduledoc """
  Provides functions to create new game and play it.
  """
  import Ecto.Query, warn: false
  alias Revival.Repo
  alias Revival.Games.{Play, Player, Timer, Move}

  @doc """
  Returns the players ranking.
  """
  def ranking do
    Repo.all(
      from p in Player, order_by: [
        desc: p.rank
      ]
    )
  end

  @doc """
  Creates new play in given mode. For now only allowed mode is `:classic`.
  Returns created play.

  ## Examples

    iex> %Revival.Games.Play{} = Revival.Games.create_play(:classic)

  """
  def create_play(mode) do
    Play.new_play(mode)
    |> Play.changeset()
    |> Repo.insert!()
  end

  @doc """
  Retrieves saved game by given `id`.

  ## Examples

    iex> play = Revival.Games.create_play(:classic)
    iex> %Revival.Games.Play{} = Revival.Games.get_play(play.id)

    iex> Revival.Games.get_play("c2f25863-3869-4c84-97d4-f521af569bf4")
    nil

  """
  def get_play(id) do
    case Repo.get(Play, id)  do
      nil -> nil
      play -> Play.unify_keys(play)
    end
  end

  @doc """
  Same as `get_play/1` but rises exception when cannot find play for given `id`.
  """
  def get_play!(id),
      do: Repo.get!(Play, id)
          |> Play.unify_keys()

  @doc """
  Retrieves registered or anonymous player.

  ## Examples

    iex> %Revival.Games.Player{} = Revival.Games.get_player(nil, "c2f25863-3869-4c84-97d4-f521af569bf4", "Adam")

  """
  def get_player(user_id, anonymous_id, name), do: Player.get_player(user_id, anonymous_id, name)

  @doc """
  Retrieves registered player for given `id` or rises exception.
  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Join given `player` to play of given `id`. One player cannot join the same play twice.

  ## Examples

    iex> play = Revival.Games.create_play(:classic)
    iex> player = Revival.Games.get_player(nil, "c2f25863-3869-4c84-97d4-f521af569bf4", "Adam")
    iex>
    iex> {:ok, play} = Revival.Games.join_play(play.id, player)
    iex> Enum.count(play.players)
    1

  """
  def join_play(id, player) do
    play = get_play!(id)

    play
    |> Play.changeset(%{players: play.players ++ [player]})
    |> Repo.update()
  end

  @doc """
  Checks if play can forward to `warming_up` phase.

  ## Examples

    iex> play = Revival.Games.create_play(:classic)
    iex> Revival.Games.can_warm_up?(play)
    false
    iex> player1 = Revival.Games.get_player(nil, "c2f25863-3869-4c84-97d4-f521af569bf4", "Adam")
    iex> player2 = Revival.Games.get_player(nil, "9b934df4-0d2b-4201-b910-aedf21e0e409", "Harald")
    iex> {:ok, play} = Revival.Games.join_play(play.id, player1)
    iex> {:ok, play} = Revival.Games.join_play(play.id, player2)
    iex> Revival.Games.can_warm_up?(play)
    true

  """
  def can_warm_up?(play), do: Play.can_warm_up?(play)

  @doc """
  Starts `warming_up` phase of given `play`. Rises an exception if warming up is not possible.

  ## Examples

    iex> play = Revival.Games.create_play(:classic)
    iex> player1 = Revival.Games.get_player(nil, "c2f25863-3869-4c84-97d4-f521af569bf4", "Adam")
    iex> player2 = Revival.Games.get_player(nil, "9b934df4-0d2b-4201-b910-aedf21e0e409", "Harald")
    iex> {:ok, play} = Revival.Games.join_play(play.id, player1)
    iex> {:ok, play} = Revival.Games.join_play(play.id, player2)
    iex> %Revival.Games.Play{status: "warming_up"} = Revival.Games.warm_up!(play, fn x -> x end)

  """
  def warm_up!(play, update_callback) do
    if !can_warm_up?(play), do: raise "Warm up not possible"

    {:ok, pid} =
      %Timer{
        play_id: play.id,
        callback: update_callback,
        timeout: Move.round_time(play.mode) * 1000 + 200
      }
      |> Timer.start()

    play
    |> Play.changeset(Play.warm_up_changes(play, pid))
    |> Repo.update!()
  end

  @doc """
  Execute when play's timer has finished counting down.
  When play is in `warming_up` status timeout start `playing` phase.
  When play is in `playing` status timeout ends play caused by not activity of one player.
  """
  def timeout(play_id) do
    play_id
    |> get_play!()
    |> handle_timeout()
  end

  defp handle_timeout(%{status: "warming_up"} = play) do
    play =
      play
      |> Play.changeset(Play.start_changes(play))
      |> Repo.update!()

    {:next, play}
  end

  defp handle_timeout(%{status: "playing"} = play) do
    play =
      play
      |> Play.changeset(Play.finish_changes(play, :timeout))
      |> Repo.update!()

    Player.handle_win(play.players, play.winner)

    {:stop, play}
  end

  @doc """
  Handle players moves made during current round.
  """
  def end_round(play_id, player_id, moves) do
    play =
      play_id
      |> get_play!()
      |> Move.ensure_correct_player_move!(player_id)

    play
    |> Play.changeset(Move.next_move_changes(play, moves))
    |> Repo.update!()
    |> notify_client
  end

  defp notify_client(play) do
    timer_pid =
      play.timer_pid
      |> String.replace_prefix("#PID", "")
      |> String.to_charlist()
      |> :erlang.list_to_pid()

    GenServer.cast(timer_pid, {:update, play})
    play
  end

  @doc """
  Returns play that can be easily converted to JSON and safely send to external client.
  """
  def client_encode(play) do
    play
    |> Map.put(:round_time, Move.round_time(play.mode))
    |> Map.put(:players, Enum.map(play.players, &Player.client_encode/1))
  end
end
