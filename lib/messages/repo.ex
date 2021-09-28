defmodule Messages.Repo do
  use Ecto.Repo,
    otp_app: :messages,
    adapter: Ecto.Adapters.Postgres
end
