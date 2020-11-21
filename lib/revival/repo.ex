defmodule Revival.Repo do
  use Ecto.Repo,
    otp_app: :revival,
    adapter: Ecto.Adapters.Postgres
end
