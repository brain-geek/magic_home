defmodule MagicHome.Sensing.SensorProcessTest do
  use MagicHome.DataCase

  setup do
    Application.put_env(:magic_home, :sensors_enabled, true)
    MagicHome.TestTools.reset_magic_home_state()

    on_exit(fn ->
      Application.put_env(:magic_home, :sensors_enabled, false)
    end)
  end

  test "get_pid/1 returns process pid" do
    sensor = insert(:fake_sensor)
    {:ok, pid} = MagicHome.Sensing.SensorManager.start(sensor.id)

    assert(^pid = MagicHome.Sensing.SensorProcess.get_pid(sensor.id))
  end
end
