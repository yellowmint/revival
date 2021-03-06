defmodule Revival.Games.Play do
  use Ecto.Schema
  import Ecto.Changeset

  alias Revival.Utils
  alias Revival.Games.{Play, Player, Board, Shop, Move}

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {
    Jason.Encoder,
    only: [
      :id,
      :mode,
      :status,
      :board,
      :shop,
      :players,
      :started_at,
      :round,
      :round_time,
      :next_move,
      :next_move_deadline,
      :winner
    ]
  }

  schema "plays" do
    field :mode, :string
    field :status, :string
    field :round, :integer
    field :round_time, :integer, virtual: true
    field :next_move, :string
    field :next_move_deadline, :utc_datetime
    field :timer_pid, :string
    field :board, :map
    field :shop, :map
    field :players, {:array, :map}
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :winner, :string
    field :lock_version, :integer, default: 1

    timestamps()
  end

  def new_play(:classic) do
    board = Board.new_board(10, 10)
    %Play{mode: "classic", status: "joining", board: board, players: []}
  end

  def can_warm_up?(play) do
    play.status == "joining" && Enum.count(play.players) == 2
  end

  def warm_up_changes(play, timer_pid) do
    %{}
    |> Map.put(:status, "warming_up")
    |> Map.put(:players, Player.prepare_players_to_play(play.players, play.mode))
    |> Map.put(:board, Board.create_revival_spots(play.board))
    |> Map.put(:shop, Shop.new_shop(play.mode))
    |> Map.put(:round, 0)
    |> Map.put(:started_at, NaiveDateTime.add(NaiveDateTime.utc_now(), 3))
    |> Map.put(:timer_pid, inspect(timer_pid))
  end

  def start_changes(play) do
    %{}
    |> Map.put(:status, "playing")
    |> Map.put(:round, 1)
    |> Map.put(:next_move, Enum.random(["blue", "red"]))
    |> Map.put(:next_move_deadline, Move.next_round_deadline(play.mode))
  end

  def finish_changes(play, :timeout) do
    %{}
    |> Map.put(:status, "finished")
    |> Map.put(:finished_at, NaiveDateTime.utc_now())
    |> Map.put(:winner, determine_winner(play, :timeout))
  end

  defp determine_winner(play, :timeout) do
    cond do
      play.round <= 5 -> "draw"
      true -> Player.opponent_for(play.next_move)
    end
  end

  def changeset(play, attrs \\ %{}) do
    play
    |> cast(
      attrs,
      [
        :mode,
        :status,
        :round,
        :next_move,
        :next_move_deadline,
        :timer_pid,
        :board,
        :shop,
        :players,
        :started_at,
        :finished_at,
        :winner
      ]
    )
    |> validate_required([:mode, :status, :board])
    |> validate_inclusion(:mode, ["classic"])
    |> validate_inclusion(:status, ["joining", "warming_up", "playing", "finished"])
    |> validate_status(play.status)
    |> optimistic_lock(:lock_version)
  end

  def validate_status(changeset, "joining") do
    changeset
    |> validate_inclusion(:status, ["joining", "warming_up"])
    |> validate_length(:players, max: 2)
    |> Utils.validate_unique_list_items_by_id(:players)
  end

  def validate_status(changeset, "warming_up") do
    changeset
    |> validate_inclusion(:status, ["warming_up", "playing"])
    |> validate_required([:players, :started_at, :shop, :timer_pid])
    |> validate_length(:players, is: 2)
  end

  def validate_status(changeset, "playing") do
    changeset
    |> validate_inclusion(:status, ["playing", "finished"])
    |> validate_required([:round, :next_move, :next_move_deadline])
  end

  def unify_keys(play) do
    play
    |> Map.put(:board, Utils.keys_to_atoms(play.board))
    |> Map.put(:players, Utils.keys_to_atoms(play.players))
    |> Map.put(:shop, Utils.keys_to_atoms(play.shop))
  end
end
