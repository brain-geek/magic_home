defmodule MagicHome.Mixfile do
  use Mix.Project

  def project do
    [
      app: :magic_home,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MagicHome.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.1"},
      {:phoenix_pubsub, "~> 1.0"},
      # {:ecto_sql, "~> 3.0"},
      {:phoenix_ecto, "~> 3.6.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},

      # Weird database
      {:ecto, "~>2.2.0"},
      {:sqlite_ecto2, "~> 2.3"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.0"},

      # Newer versions break everything, see https://github.com/elixir-sqlite/sqlitex/issues/75#issue-428883337
      {:sqlitex, "1.5.1"},

      # Connectors to external world
      {:huex, "~> 0.8"},
      # Might need to go to firmware
      # Needs cowboy ~> 2.2 which is not supported by Phoenix yet
      # {:lifx, github: "rosetta-home/lifx"},

      # Logic in actors
      {:ex_process, github: "brain-geek/ex_process"},

      # Development stuff
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},

      # Test stuff
      {:ex_machina, "~> 2.3", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
