defmodule MagicHome.Sensing.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      supervisor(Registry, [:unique, MagicHome.Sensing.SensorRegistry]),
      {DynamicSupervisor,
       name: MagicHome.Sensing.SensorSupervisor, strategy: :one_for_one, restart: :permanent},
      {MagicHome.Sensing.SensorManager, name: MagicHome.Sensing.SensorRegistry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
