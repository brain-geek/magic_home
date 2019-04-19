defmodule MagicHome.Sensing.SensorManager do
  use GenServer

  @supervisor_process MagicHome.Sensing.SensorSupervisor
  @process_module MagicHome.Sensing.SensorProcess

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    GenServer.cast(self(), :run_all)

    {:ok, nil}
  end

  def start(sensor_id) when is_binary(sensor_id) do
    start(MagicHome.Sensing.get_sensor!(sensor_id))
  end

  def start(sensor = %MagicHome.Sensing.Sensor{}) do
    if Application.get_env(:magic_home, :sensors_enabled) do
      child_spec = sensor_child_spec(sensor)
      DynamicSupervisor.start_child(@supervisor_process, child_spec)
    else
      {:error, "Sensor processes start disabled"}
    end
  end

  def terminate(sensor_id) when is_binary(sensor_id) do
    if Application.get_env(:magic_home, :sensors_enabled) do
      pid = @process_module.get_pid(sensor_id)
      DynamicSupervisor.terminate_child(@supervisor_process, pid)
    end
  end

  @doc false
  def handle_cast(:run_all, state) do
    MagicHome.Sensing.list_sensors()
    |> Enum.each(&start(&1))

    {:noreply, state}
  end

  defp sensor_child_spec(sensor = %MagicHome.Sensing.Sensor{type: "fake"}) do
    {MagicHome.Sensing.FakeSensor, %{sensor: sensor}}
  end

  defp sensor_child_spec(sensor = %MagicHome.Sensing.Sensor{type: "gpio_switch"}) do
    sensor = sensor |> MagicHome.Repo.preload(:gpio)
    {MagicHome.Sensing.GpioSensor, %{sensor: sensor}}
  end
end
