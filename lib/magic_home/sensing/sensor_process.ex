defmodule MagicHome.Sensing.SensorProcess do
  @moduledoc """
  Generic interface for interfacing with sensors.
  """

  use MagicHome.Sensing.SensorProcessGeneric

  @doc "Returns pid of the given process"
  def get_pid(sensor_id) when is_binary(sensor_id) do
    [{pid, pid}] = Registry.lookup(@process_registry, registry_name_key(sensor_id))
    pid
  end

  @doc false
  def simulate_trigger(%Sensor{id: sensor_id}, data) do
    simulate_trigger(sensor_id, data)
  end

  @doc false
  def simulate_trigger(sensor_id, data) when is_binary(sensor_id) do
    GenServer.cast(get_pid(sensor_id), {:simulate_trigger, data})
  end
end
