defmodule Revival.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    field :email, :string
    field(:password, :string, virtual: true)
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset_create(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> validate_required([:email, :password, :name])
    |> validate_length(:name, min: 3, max: 255)
    |> validate_length(:password, min: 8, max: 255)
    |> validate_length(:email, min: 3, max: 255)
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/)
    |> unique_constraint(:email)
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
