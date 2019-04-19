defmodule MagicHome.Lights.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      supervisor(Registry, [:unique, MagicHome.Lights.LampRegistry]),
      {DynamicSupervisor,
       name: MagicHome.Lights.LampSupervisor, strategy: :one_for_one, restart: :permanent},
      {MagicHome.Lights.LampManager, name: MagicHome.Lights.LampRegistry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
