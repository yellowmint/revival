defmodule Revival.Games.Play do
  use Ecto.Schema
  import Ecto.Changeset

  alias Revival.Games.{Play, Board}

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :mode, :round, :board, :players]}

  schema "plays" do
    field :mode, :string
    field :round, :integer
    field :board, :map
    field :players, {:array, :map}
    field :lock_version, :integer, default: 1

    timestamps()
  end

  def new_play(:classic) do
    board = Board.new_board(10, 10)
    %Play{mode: "classic", round: 0, board: board, players: []}
  end

  @doc false
  def changeset(play, attrs \\ %{}) do
    play
    |> cast(attrs, [:mode, :round, :board, :players])
    |> validate_required([:mode])
    |> validate_inclusion(:mode, ["classic"])
    |> validate_length(:players, max: 2)
    |> validate_unique_list(:players)
    |> optimistic_lock(:lock_version)
  end

  def validate_unique_list(changeset, field) do
    validate_change(changeset, field, fn _, list ->
      case Enum.uniq(list) do
        ^list -> []
        _ -> [{field, "list contains duplication"}]
      end
    end)
  end
end
