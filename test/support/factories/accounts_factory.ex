defmodule Revival.AccountsFactory do
  use ExMachina.Ecto, repo: Revival.Repo

  def user_factory() do
    %Revival.Accounts.User{
      email: "mike@therevival.space",
      name: "Mike",
      password_hash: "queen's gambit" |> Pbkdf2.hash_pwd_salt()
    }
  end
end
