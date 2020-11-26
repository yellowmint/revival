defmodule Revival.Games.Play do
  use Ecto.Schema
  import Ecto.Changeset

  alias Revival.Games.{Play, Board, Player}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "plays" do
    field :mode, :string
    field :round, :integer
    field :board, :map
    field :players, {:array, :map}

    timestamps()
  end

  def new_play(:classic) do
    board = Board.new_board(10, 10)
    players = [%Player{}, %Player{}]

    %Play{mode: :classic, round: 1, board: board, players: players}
  end

  @doc false
  def changeset(play, attrs \\ %{}) do
    play
    |> convert_atoms_to_strings
    |> cast(attrs, [:mode, :round, :board, :players])
    |> validate_required([:mode])
    |> validate_inclusion(:mode, [:classic])
  end

  defp convert_atoms_to_strings(play) do
    %{play | mode: Atom.to_string(play.mode)}
  end
end
