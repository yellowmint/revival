defmodule Revival.Games.Play do
  use Ecto.Schema
  import Ecto.Changeset

  alias Revival.Utils
  alias Revival.Games.{Play, Board}

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :mode, :board, :players, :started_at, :round, :round_time, :next_move, :next_move_deadline]}

  schema "plays" do
    field :mode, :string
    field :status, :string
    field :round, :integer
    field :round_time, :integer, virtual: true
    field :next_move, :string
    field :next_move_deadline, :utc_datetime
    field :board, :map
    field :players, {:array, :map}
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
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

  def warm_up_play(play) do
    play = Map.put(play, :players, Enum.shuffle(play.players))

    play
    |> Map.put(:status, "warming_up")
    |> Map.put(:started_at, next_round_deadline(play))
    |> Map.put(:players, put_labels_to_players(play.players))
    |> Map.put(:board, Board.create_revival_spots(play.board))
    |> Map.from_struct()
  end

  defp put_labels_to_players([player1, player2]) do
    [Map.put(player1, :label, :blue), Map.put(player2, :label, :red)]
  end

  def start_play(play) do
    play
    |> Map.put(:status, "playing")
    |> Map.put(:round, 1)
    |> Map.put(:next_move, Enum.random([:blue, :red]))
    |> Map.put(:next_move_deadline, next_round_deadline(play))
  end

  def changeset(play, attrs \\ %{}) do
    play
    |> cast(attrs, [:mode, :status, :round, :next_move, :next_move_deadline, :board, :players,
                    :started_at, :finished_at])
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
    |> validate_required([:players, :round, :next_move, :next_move_deadline, :started_at])
    |> validate_length(:players, is: 2)
  end

  def round_time("classic"), do: 10

  def next_round_deadline(%{mode: mode}) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(round_time(mode))
  end

  def unify_keys(play) do
    play
    |> Map.put(:board, Utils.convert_map_keys_to_atoms(play.board))
    |> Map.put(:players, Enum.map(play.players, &Utils.convert_map_keys_to_atoms/1))
  end
end
