defmodule MagicHome.Lights.GpioLamp do
  use GenServer
  use MagicHome.Lights.LampProcessGeneric

  require Logger

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

    gpio_id = opts[:lamp].gpio.number

    {:ok, gpio_ref} = Circuits.GPIO.open(gpio_id, :output)
    Circuits.GPIO.write(gpio_ref, 1)

    opts = %{status: false, lamp: opts[:lamp], gpio_id: gpio_id, gpio_ref: gpio_ref}

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

    set_lamp_state(state)

    {:reply, state[:status], state}
  end

  @doc false
  def handle_call(:light_down, _from, state) do
    state = put_in(state[:status], false)

    set_lamp_state(state)

    {:reply, state[:status], state}
  end

  @doc false
  def handle_call(:light_toggle, _from, state) do
    state = put_in(state[:status], !state[:status])

    set_lamp_state(state)

    {:reply, state[:status], state}
  end

  defp set_lamp_state(%{gpio_ref: gpio_ref, status: true}) do
    Logger.info("Setting 0 on #{Circuits.GPIO.pin(gpio_ref)}")
    Circuits.GPIO.write(gpio_ref, 0)
  end

  defp set_lamp_state(%{gpio_ref: gpio_ref, status: false}) do
    Logger.info("Setting 1 on #{Circuits.GPIO.pin(gpio_ref)}")
    Circuits.GPIO.write(gpio_ref, 1)
  end
end
