defmodule Revival.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias Revival.{Repo, Accounts}
  alias Revival.Games.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :name, :rank, :user_id]}

  schema "players" do
    field :name, :string
    field :rank, :integer
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(player, attrs \\ %{}) do
    player
    |> cast(attrs, [:user_id, :name, :rank])
    |> validate_required([:user_id, :name, :rank])
  end

  def get_player(nil, name) do
    %Player{id: Ecto.UUID.generate, user_id: nil, name: name, rank: 0}
  end

  def get_player(user_id, _name) do
    case Repo.get_by(Player, user_id: user_id) do
      nil ->
        user = Accounts.get_user!(user_id)

        %Player{user_id: user_id, name: user.name, rank: 0}
        |> Player.changeset()
        |> Repo.insert!()

      player -> player
    end
  end
end
