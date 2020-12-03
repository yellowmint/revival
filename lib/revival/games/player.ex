defmodule Revival.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Revival.{Repo, Accounts}
  alias Revival.Games.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :name, :rank, :user_id, :label, :wallet]}

  def client_encode(player) do
    Map.take(player, [:id, :name, :rank, :label, :wallet])
  end

  schema "players" do
    field :name, :string
    field :rank, :integer
    field :user_id, :binary_id
    field :label, :string, virtual: true
    field :wallet, :map, virtual: true

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

  def get_player(user_id, _anonymous_id, _name) do
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

  def handle_win(_players, "draw"), do: nil
  def handle_win(players, winner) do
    Enum.each(players, fn player ->
      if winner == player.label, do: increase_rank(player.user_id),
                                 else: decrease_rank(player.user_id)
    end)
  end

  defp increase_rank(nil), do: nil
  defp increase_rank(user_id) do
    Repo.update(from p in Player, where: p.user_id == ^user_id, update: [inc: [rank: 1]])
  end

  defp decrease_rank(nil), do: nil
  defp decrease_rank(user_id) do
    Repo.update(from p in Player, where: p.user_id == ^user_id and p.rank > 1, update: [inc: [rank: -1]])
  end
end
