defmodule MagicHome.Sensing.SensorManagerTest do
  use MagicHome.DataCase

  setup do
    MagicHome.TestTools.reset_magic_home_state()
    MagicHome.TestTools.reset_bpm_state()
    Application.put_env(:magic_home, :sensors_enabled, true)
  end

  test "start/1 starts the specified process" do
    fake_sensor = insert(:fake_sensor)

    {:ok, _sensor_pid} = MagicHome.Sensing.SensorManager.start(fake_sensor.id)

    assert(1 = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor)))
  end

  test "start/1 does nothing if :sensors_enabled config env is false" do
    Application.put_env(:magic_home, :sensors_enabled, false)

    fake_sensor = insert(:fake_sensor)

    {:error, "Sensor processes start disabled"} =
      MagicHome.Sensing.SensorManager.start(fake_sensor.id)

    assert(0 = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor)))
  end

  test "init/1 starts processes existing in DB when starting (on crash)" do
    insert(:fake_sensor)

    assert(Enum.empty?(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor)))

    MagicHome.Sensing.SensorManager.handle_cast(:run_all, nil)

    assert(1 = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor)))
  end

  test "terminate/1 stops the specified process" do
    fake_sensor = insert(:fake_sensor)

    MagicHome.Sensing.SensorManager.start(fake_sensor.id)
    assert(1 = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor)))

    MagicHome.Sensing.SensorManager.terminate(fake_sensor.id)
    assert(0 = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor)))
  end

  describe "BPM integration" do
    test "triggers events" do
      on_exit(fn ->
        MagicHome.TestTools.reset_bpm_state()
      end)

      sensor = insert(:fake_sensor)
      ExProcess.PubSub.subscribe(self(), {:sensor, sensor.id})

      MagicHome.Sensing.SensorManager.handle_cast(:run_all, nil)

      MagicHome.Sensing.SensorProcess.simulate_trigger(sensor, {:test, :event})

      sensor_id = sensor.id

      assert_receive %ExProcess.PubSub.Message{
        channel: {:sensor, ^sensor_id},
        info: {:test, :event}
      }
    end

    test "registers event receiver" do
      on_exit(fn ->
        MagicHome.TestTools.reset_bpm_state()
      end)

      sensor = insert(:fake_sensor, name: "Definitely a switch")
      MagicHome.Sensing.SensorManager.handle_cast(:run_all, nil)

      assert(
        ExProcess.Matcher.EventReceive.get_subscribe_data("Definitely a switch triggered") ==
          [
            {"Definitely a switch triggered", {:sensor, sensor.id}}
          ]
      )
    end
  end
end
