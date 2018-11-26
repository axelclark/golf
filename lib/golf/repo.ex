defmodule Golf.Repo do
  use Ecto.Repo,
    otp_app: :golf,
    adapter: Ecto.Adapters.Postgres
end
