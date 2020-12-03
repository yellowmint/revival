defmodule Revival.Repo.Migrations.ConvertPlayersToJsonb do
  use Ecto.Migration

  def up do
    execute "alter table plays alter column players type jsonb using to_json(players);"
  end
end
