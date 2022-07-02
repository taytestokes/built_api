defmodule BuiltApi.Repo do
  use Ecto.Repo,
    otp_app: :built_api,
    adapter: Ecto.Adapters.Postgres
end
