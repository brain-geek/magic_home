defmodule MagicHome.Sensing.GpioSensor do
  use GenServer
  use MagicHome.Sensing.SensorProcessGeneric
  require Logger

  def start_link(opts = %{sensor: %Sensor{id: sensor_id}}) do
    GenServer.start_link(
      __MODULE__,
      opts,
      name: process_name(sensor_id)
    )
  end

  @doc false
  def init(%{sensor: (%Sensor{id: sensor_id, name: sensor_name, gpio: gpio})}) do
    Registry.register(@process_registry, registry_name_key(sensor_id), self())
    Registry.register(@process_registry, registry_pid_key(self()), sensor_id)

    ExProcess.Matcher.EventReceive.register_matcher(
      "#{sensor_name} triggered",
      {:sensor, sensor_id}
    )

    {:ok, gpio_ref} = Circuits.GPIO.open(gpio.number, :input)
    gpio_state = Circuits.GPIO.read(gpio_ref)
    schedule_check()

    state = %{gpio: gpio_ref, state: gpio_state, sensor_id: sensor_id}

    {:ok, state}
  end

  def handle_info(:check_input, state = %{gpio: gpio_ref, state: prev_state, sensor_id: sensor_id}) do
    schedule_check()

    new_state = Circuits.GPIO.read(gpio_ref)

    if new_state != prev_state do
      Logger.info "Received change of state to #{new_state} on #{Circuits.GPIO.pin(gpio_ref)}"

      ExProcess.PubSub.broadcast({:sensor, sensor_id}, %{new_state: new_state})
      state = put_in(state[:state], new_state)

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  defp schedule_check() do
    Process.send_after(self(), :check_input, 100)
  end
end
