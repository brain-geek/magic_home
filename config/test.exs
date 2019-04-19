use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :magic_home, MagicHomeWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :magic_home, MagicHome.Repo,
  adapter: Sqlite.Ecto2,
  database: "magic_home_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 60_000
