defmodule MagicHome.TestTools do
  def reset_bpm_state do
    # Clear processes
    Supervisor.terminate_child(ExProcess.Supervisor, ExProcess.ProcessSupervisor)
    Supervisor.restart_child(ExProcess.Supervisor, ExProcess.ProcessSupervisor)

    # Clear matchers
    Agent.update(ExProcess.Matcher.Task, fn _ -> MapSet.new() end)
    Agent.update(ExProcess.Matcher.EventPublish, fn _ -> MapSet.new() end)
    Agent.update(ExProcess.Matcher.EventReceive, fn _ -> MapSet.new() end)
    Agent.update(ExProcess.Matcher.FlowCondition, fn _ -> MapSet.new() end)

    :ok
  end

  def reset_magic_home_state do
    # Clear magic home lights processes
    Supervisor.terminate_child(MagicHome.Supervisor, MagicHome.Lights.Supervisor)
    Supervisor.restart_child(MagicHome.Supervisor, MagicHome.Lights.Supervisor)
    Supervisor.terminate_child(MagicHome.Supervisor, MagicHome.Sensing.Supervisor)
    Supervisor.restart_child(MagicHome.Supervisor, MagicHome.Sensing.Supervisor)

    Process.sleep 10 # Without this, we're getting race condition on lamps/sensors autostart
    :ok
  end

  def disable_feature_flags do
    Application.put_env(:magic_home, :lamps_enabled, false)
    Application.put_env(:magic_home, :sensors_enabled, false)
  end

  def fixture(name) do
    File.read!("./test/fixtures/#{name}.bpmn")
  end

  def parsed_fixture(name) do
    {:ok, process} = name |> fixture() |> ExProcess.Bpmn.Parser.parse()
    process
  end
end
