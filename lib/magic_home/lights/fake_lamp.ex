defmodule MagicHome.Lights.FakeLamp do
  use GenServer
  use MagicHome.Lights.LampProcessGeneric

  def start_link(opts = %{lamp: %Lamp{id: lamp_id}}) do
    GenServer.start_link(
      __MODULE__,
      opts,
      name: process_name(lamp_id)
    )
  end

  @doc false
  def init(opts = %{lamp: %Lamp{id: lamp_id}}) do
    Registry.register(@process_registry, registry_name_key(lamp_id), self())
    Registry.register(@process_registry, registry_pid_key(self()), lamp_id)

    opts = Map.put(opts, :status, false)

    {:ok, opts}
  end

  @doc false
  def handle_call(:status, _from, state = %{status: false}) do
    {:reply, :off, state}
  end

  @doc false
  def handle_call(:status, _from, state = %{status: true}) do
    {:reply, :on, state}
  end

  @doc false
  def handle_call(:light_up, _from, state) do
    state = put_in(state[:status], true)

    {:reply, state[:status], state}
  end

  @doc false
  def handle_call(:light_down, _from, state) do
    state = put_in(state[:status], false)

    {:reply, state[:status], state}
  end

  @doc false
  def handle_call(:light_toggle, _from, state) do
    state = put_in(state[:status], !state[:status])

    {:reply, state[:status], state}
  end
end
