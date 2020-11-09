# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_upload,
  ecto_repos: [LiveUpload.Repo]

# Configures the endpoint
config :live_upload, LiveUploadWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "39tS7D3O927nJqdiZts1TaZBu6W240TdwQ48WoDk1RhhDUgb4/C+1yO37ejAkSzP",
  render_errors: [view: LiveUploadWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveUpload.PubSub,
  live_view: [signing_salt: "l9BjXE7K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
