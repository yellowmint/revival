defmodule Revival.Games.Player do
  alias Revival.Accounts
  alias Revival.Games.Player

  @derive Jason.Encoder
  defstruct [:id, :user_id, :name, :rank]

  def new_player(nil, name) do
    %Player{id: Ecto.UUID.generate, user_id: nil, name: name, rank: 0}
  end

  def new_player(user_id, _name) do
    user = Accounts.get_user!(user_id)
    %Player{id: Ecto.UUID.generate, user_id: user_id, name: user.name, rank: 0}
  end
end
