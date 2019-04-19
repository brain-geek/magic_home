defmodule MagicHome.Lights.LampManagerTest do
  use MagicHome.DataCase

  setup do
    MagicHome.TestTools.reset_magic_home_state()
    MagicHome.TestTools.reset_bpm_state()
    Application.put_env(:magic_home, :lamps_enabled, true)
  end

  test "start/1 starts the specified process" do
    fake_lamp = insert(:fake_lamp)

    {:ok, lamp_pid} = MagicHome.Lights.LampManager.start(fake_lamp.id)

    assert(1 = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor)))
    assert(:off = GenServer.call(lamp_pid, :status))
  end

  test "start/1 does nothing if :lamps_enabled config env is false" do
    Application.put_env(:magic_home, :lamps_enabled, false)

    fake_lamp = insert(:fake_lamp)
    {:error, "Lamp processes start disabled"} = MagicHome.Lights.LampManager.start(fake_lamp.id)

    assert(0 = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor)))
  end

  test "init/1 starts processes existing in DB when starting (on crash)" do
    insert(:fake_lamp)

    assert(Enum.empty?(Supervisor.which_children(MagicHome.Lights.LampSupervisor)))

    MagicHome.Lights.LampManager.handle_cast(:run_all, nil)

    assert(1 = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor)))
  end

  test "terminate/1 stops the specified process" do
    fake_lamp = insert(:fake_lamp)

    MagicHome.Lights.LampManager.start(fake_lamp.id)
    assert(1 = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor)))

    MagicHome.Lights.LampManager.terminate(fake_lamp.id)
    assert(0 = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor)))
  end

  describe "BPM integration" do
    setup do
      MagicHome.TestTools.reset_bpm_state()
    end

    test "registers task matchers" do
      fake_lamp = insert(:fake_lamp, name: "Fake switch zero")
      {:ok, _} = MagicHome.Lights.LampManager.start(fake_lamp.id)
      assert(:off = MagicHome.Lights.LampProcess.status(fake_lamp))

      ExProcess.Matcher.Task.run_match("Enable light Fake switch zero")
      assert(:on = MagicHome.Lights.LampProcess.status(fake_lamp))

      ExProcess.Matcher.Task.run_match("Disable light Fake switch zero")
      assert(:off = MagicHome.Lights.LampProcess.status(fake_lamp))

      ExProcess.Matcher.Task.run_match("Toggle light Fake switch zero")
      assert(:on = MagicHome.Lights.LampProcess.status(fake_lamp))
      ExProcess.Matcher.Task.run_match("Toggle light Fake switch zero")
      assert(:off = MagicHome.Lights.LampProcess.status(fake_lamp))
    end

    test "registers flow condition matchers" do
      fake_lamp = insert(:fake_lamp, name: "Fake switch zero")
      {:ok, _} = MagicHome.Lights.LampManager.start(fake_lamp.id)

      assert(ExProcess.Matcher.FlowCondition.run_match("Light Fake switch zero is lit") == false)

      assert(
        ExProcess.Matcher.FlowCondition.run_match("Light Fake switch zero is not lit") == true
      )

      ExProcess.Matcher.Task.run_match("Enable light Fake switch zero")

      assert(ExProcess.Matcher.FlowCondition.run_match("Light Fake switch zero is lit") == true)

      assert(
        ExProcess.Matcher.FlowCondition.run_match("Light Fake switch zero is not lit") == false
      )
    end
  end
end
