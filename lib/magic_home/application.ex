defmodule MagicHome.Application do
  @moduledoc """
  Application supervisor process
  """
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    :ok = setup_db!()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(MagicHome.Repo, []),
      # Start the endpoint when the application starts
      supervisor(MagicHomeWeb.Endpoint, []),
      # # Lamp processes supervisor
      supervisor(MagicHome.Lights.Supervisor, []),
      supervisor(MagicHome.Sensing.Supervisor, []),
      worker(MagicHome.ProcessContext.ProcessRunner, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MagicHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MagicHomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # https://embedded-elixir.com/post/2017-09-22-using-ecto-and-sqlite3-with-nerves/
  @otp_app Mix.Project.config()[:app]

  defp setup_db! do
    repos = Application.get_env(@otp_app, :ecto_repos)

    for repo <- repos do
      if Application.get_env(@otp_app, repo)[:adapter] == Sqlite.Ecto2 do
        setup_repo!(repo)
        migrate_repo!(repo)
      end
    end

    :ok
  end

  defp setup_repo!(repo) do
    db_file = Application.get_env(@otp_app, repo)[:database]

    unless File.exists?(db_file) do
      :ok = repo.__adapter__.storage_up(repo.config)
    end
  end

  defp migrate_repo!(repo) do
    opts = [all: true]
    {:ok, pid, apps} = Mix.Ecto.ensure_started(repo, opts)

    migrator = &Ecto.Migrator.run/4
    pool = repo.config[:pool]
    migrations_path = Path.join([:code.priv_dir(@otp_app) |> to_string, "repo", "migrations"])

    migrated =
      if function_exported?(pool, :unboxed_run, 2) do
        pool.unboxed_run(repo, fn -> migrator.(repo, migrations_path, :up, opts) end)
      else
        migrator.(repo, migrations_path, :up, opts)
      end

    pid && repo.stop(pid)
    Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  end
end
