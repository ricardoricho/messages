# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :messages,
  ecto_repos: [Messages.Repo]

# Configures the endpoint
config :messages, MessagesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZEZy+ol4Smi938w6y+2aE9V/zVaZ4B6EOUt/JMxjUGXGwztJIagDyCK5Tmjc60zv",
  render_errors: [view: MessagesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Messages.PubSub,
  live_view: [signing_salt: "OyEsrrrX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
