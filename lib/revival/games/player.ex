defmodule Revival.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Revival.Repo
  alias Revival.{Repo, Accounts}
  alias Revival.Games.{Player, Wallet}

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :name, :rank, :user_id, :label, :live, :wallet]}

  def client_encode(player) do
    Map.take(player, [:id, :name, :rank, :label, :live, :wallet])
  end

  schema "players" do
    field :name, :string
    field :rank, :integer
    field :user_id, :binary_id
    field :label, :string, virtual: true
    field :live, :integer, virtual: true
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

  def opponent_for("blue"), do: "red"
  def opponent_for("red"), do: "blue"

  defp create_player(user_id) do
    user = Accounts.get_user!(user_id)

    %Player{user_id: user_id, name: user.name, rank: 0}
    |> Player.changeset()
    |> Repo.insert!()
  end

  def prepare_players_to_play(players, mode) do
    players
    |> Enum.shuffle()
    |> List.update_at(0, &Map.put(&1, :label, "blue"))
    |> List.update_at(1, &Map.put(&1, :label, "red"))
    |> Enum.map(&Map.put(&1, :wallet, Wallet.new_wallet(mode)))
    |> Enum.map(&Map.put(&1, :live, initial_live(mode)))
  end

  defp initial_live("classic"), do: 100

  def spend!(%{wallet: wallet} = player, price) do
    wallet = Wallet.withdraw!(wallet, price)
    %{player | wallet: wallet}
  end

  def handle_win(_players, "draw"), do: nil

  def handle_win(players, winner) do
    Enum.each(players, fn player ->
      if winner == player.label,
        do: increase_rank(player.user_id),
        else: decrease_rank(player.user_id)
    end)
  end

  defp increase_rank(nil), do: nil

  defp increase_rank(user_id) do
    Repo.update_all(from(p in Player, where: p.user_id == ^user_id), inc: [rank: 1])
  end

  defp decrease_rank(nil), do: nil

  defp decrease_rank(user_id) do
    Repo.update_all(from(p in Player, where: p.user_id == ^user_id and p.rank > 1),
      inc: [rank: -1]
    )
  end
end
