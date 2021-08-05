defmodule PrimitiveBank.Repo do
  use Ecto.Repo,
    otp_app: :primitive_bank,
    adapter: Ecto.Adapters.Postgres
end
