defmodule MagicHome.Sensing.GpioSensor do
  use GenServer
  use MagicHome.Sensing.SensorProcessGeneric

  alias MagicHome.Sensing.SensorProcess

  def start_link(opts = %{sensor: %Sensor{id: sensor_id}}) do
    GenServer.start_link(
      __MODULE__,
      opts,
      name: process_name(sensor_id)
    )
  end

  @doc false
  def init(opts = %{sensor: %Sensor{id: sensor_id}}) do
    Registry.register(@process_registry, registry_name_key(sensor_id), self())
    Registry.register(@process_registry, registry_pid_key(self()), sensor_id)

    # TODO: add event tie-ins here

    {:ok, opts}
  end
end
