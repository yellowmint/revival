defmodule Revival.Repo.Migrations.AddShopToPlay do
  use Ecto.Migration

  def change do
    alter table(:plays) do
      add :shop, :map
    end
  end
end
