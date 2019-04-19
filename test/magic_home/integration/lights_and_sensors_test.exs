defmodule MagicHome.Integration.LightsAndSensorsTest do
  use MagicHome.DataCase

  setup do
    Application.put_env(:magic_home, :lamps_enabled, true)
    Application.put_env(:magic_home, :sensors_enabled, true)
    MagicHome.TestTools.reset_magic_home_state()
    MagicHome.TestTools.reset_bpm_state()
  end

  test "1 event, 1 task bpmn - event which causes lamp toggling" do
    sensor = insert(:fake_sensor, name: "The Sensor")
    lamp = insert(:fake_lamp, name: "The Lamp")

    MagicHome.Lights.LampManager.start(lamp)
    MagicHome.Sensing.SensorManager.handle_cast(:run_all, nil)

    valid_attrs =
      params_for(:process, body: MagicHome.TestTools.fixture("bpm/one_sensor_one_light"))

    {:ok, process_record} = MagicHome.ProcessContext.create_process_record(valid_attrs)

    pr_id = process_record.id

    assert(
      [
        {_, ^pr_id}
      ] = ExProcess.RunnerProcess.list_running()
    )

    assert(:off = MagicHome.Lights.LampProcess.status(lamp))

    MagicHome.Sensing.SensorProcess.simulate_trigger(sensor, %{state: true})

    Process.sleep(50)

    assert(:on = MagicHome.Lights.LampProcess.status(lamp))
  end
end
