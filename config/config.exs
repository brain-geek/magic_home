# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :magic_home,
  ecto_repos: [MagicHome.Repo]

# Configures the endpoint
config :magic_home, MagicHomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GooThgbn9kdUOcHJY401nNs84g64pnHZ/zyIrkBrsE6JDRYo4ctRRV+9OXDn0PY5",
  render_errors: [view: MagicHomeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MagicHome.PubSub, adapter: Phoenix.PubSub.PG2]

config :magic_home, :bpm_executor, MagicHome.ProcessContext.ProcessExecutorExProcess
config :magic_home, :lamps_enabled, true
config :magic_home, :sensors_enabled, true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
