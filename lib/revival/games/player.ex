defmodule Revival.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias Revival.{Repo, Accounts}
  alias Revival.Games.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :name, :rank, :user_id, :label]}

  def client_encode(player) do
    Map.take(player, [:name, :rank, :label])
  end

  schema "players" do
    field :name, :string
    field :rank, :integer
    field :user_id, :binary_id
    field(:label, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(player, attrs \\ %{}) do
    player
    |> cast(attrs, [:user_id, :name, :rank])
    |> validate_required([:user_id, :name, :rank])
  end

  def get_player(nil, anonymous_id, name) do
    %Player{id: anonymous_id, user_id: nil, name: name, rank: 0}
  end

  def get_player(user_id, nil, _name) do
    case Repo.get_by(Player, user_id: user_id) do
      nil -> create_player(user_id)
      player -> player
    end
  end

  defp create_player(user_id) do
    user = Accounts.get_user!(user_id)

    %Player{user_id: user_id, name: user.name, rank: 0}
    |> Player.changeset()
    |> Repo.insert!()
  end
end
