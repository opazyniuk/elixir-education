# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :primitive_bank,
  ecto_repos: [PrimitiveBank.Repo]

# Configures the endpoint
config :primitive_bank, PrimitiveBankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WhnvTxgX2v7bAT4QLJFtnhrtBIt1+DMPAfKND3Xuygowo4KJmjMlm/l6yrLj28tJ",
  render_errors: [view: PrimitiveBankWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PrimitiveBank.PubSub,
  live_view: [signing_salt: "r5cpSqP4"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
