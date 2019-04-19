defmodule MagicHome.Lights.LampProcess do
  @moduledoc """
  Generic interface for interfacing with lamps.
  """

  use MagicHome.Lights.LampProcessGeneric

  @doc "Returns status of the lamp"
  def status(%Lamp{id: lamp_id}) do
    status(lamp_id)
  end

  def status(lamp_id) when is_binary(lamp_id) do
    GenServer.call(get_pid(lamp_id), :status)
  end

  @doc "Returns pid of the given process"
  def get_pid(lamp_id) when is_binary(lamp_id) do
    [{pid, pid}] = Registry.lookup(@process_registry, registry_name_key(lamp_id))
    pid
  end

  @doc "Enables light"
  def light_up(%Lamp{id: lamp_id}) do
    light_up(lamp_id)
  end

  def light_up(lamp_id) when is_binary(lamp_id) do
    GenServer.call(get_pid(lamp_id), :light_up)
  end

  @doc "Disables light"
  def light_down(%Lamp{id: lamp_id}) do
    light_down(lamp_id)
  end

  def light_down(lamp_id) when is_binary(lamp_id) do
    GenServer.call(get_pid(lamp_id), :light_down)
  end

  @doc "Toggles light state"
  def light_toggle(%Lamp{id: lamp_id}) do
    light_toggle(lamp_id)
  end

  def light_toggle(lamp_id) when is_binary(lamp_id) do
    GenServer.call(get_pid(lamp_id), :light_toggle)
  end
end
