defmodule MagicHome.Sensing.FakeSensor do
  use GenServer
  use MagicHome.Sensing.SensorProcessGeneric

  def start_link(opts = %{sensor: %Sensor{id: sensor_id}}) do
    GenServer.start_link(
      __MODULE__,
      opts,
      name: process_name(sensor_id)
    )
  end

  @doc false
  def init(opts = %{sensor: %Sensor{id: sensor_id, name: sensor_name}}) do
    Registry.register(@process_registry, registry_name_key(sensor_id), self())
    Registry.register(@process_registry, registry_pid_key(self()), sensor_id)

    ExProcess.Matcher.EventReceive.register_matcher(
      "#{sensor_name} was triggered",
      {:sensor, sensor_id}
    )

    {:ok, opts}
  end

  @doc false
  def handle_cast({:simulate_trigger, msg}, state = %{sensor: %Sensor{id: sensor_id}}) do
    ExProcess.PubSub.broadcast({:sensor, sensor_id}, msg)

    {:noreply, state}
  end
end
