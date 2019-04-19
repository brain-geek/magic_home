defmodule MagicHome.Lights.LampManager do
  use GenServer

  @supervisor_process MagicHome.Lights.LampSupervisor
  @process_module MagicHome.Lights.LampProcess

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    GenServer.cast(self(), :run_all)

    {:ok, nil}
  end

  def start(lamp_id) when is_binary(lamp_id) do
    start(MagicHome.Lights.get_lamp!(lamp_id))
  end

  def start(lamp = %MagicHome.Lights.Lamp{}) do
    if Application.get_env(:magic_home, :lamps_enabled) do
      child_spec = lamp_child_spec(lamp)
      {:ok, pid} = DynamicSupervisor.start_child(@supervisor_process, child_spec)

      register_lamp(lamp)

      {:ok, pid}
    else
      {:error, "Lamp processes start disabled"}
    end
  end

  def terminate(lamp_id) when is_binary(lamp_id) do
    if Application.get_env(:magic_home, :lamps_enabled) do
      pid = @process_module.get_pid(lamp_id)
      DynamicSupervisor.terminate_child(@supervisor_process, pid)
    end
  end

  @doc false
  def handle_cast(:run_all, state) do
    MagicHome.Lights.list_lamps()
    |> Enum.each(&start(&1))

    {:noreply, state}
  end

  defp lamp_child_spec(lamp = %MagicHome.Lights.Lamp{type: "fake"}) do
    {MagicHome.Lights.FakeLamp, %{lamp: lamp}}
  end

  defp lamp_child_spec(lamp = %MagicHome.Lights.Lamp{type: "gpio"}) do
    lamp = lamp |> MagicHome.Repo.preload(:gpio)
    {MagicHome.Lights.GpioLamp, %{lamp: lamp}}
  end

  defp register_lamp(lamp = %MagicHome.Lights.Lamp{id: lamp_id}) do
    ExProcess.Matcher.Task.register_matcher(
      "Enable #{lamp.name}",
      fn _ -> @process_module.light_up(lamp_id) end
    )

    ExProcess.Matcher.Task.register_matcher(
      "Disable #{lamp.name}",
      fn _ -> @process_module.light_down(lamp_id) end
    )

    ExProcess.Matcher.Task.register_matcher(
      "Toggle #{lamp.name}",
      fn _ -> @process_module.light_toggle(lamp_id) end
    )

    ExProcess.Matcher.FlowCondition.register_matcher(
      "Light #{lamp.name} lit",
      fn _ -> @process_module.status(lamp_id) == :on end
    )

    ExProcess.Matcher.FlowCondition.register_matcher(
      "Light #{lamp.name} not lit",
      fn _ -> @process_module.status(lamp_id) == :off end
    )
  end
end
