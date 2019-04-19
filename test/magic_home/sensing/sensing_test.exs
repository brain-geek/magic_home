defmodule MagicHome.SensingTest do
  use MagicHome.DataCase

  alias MagicHome.Sensing

  describe "sensors" do
    alias MagicHome.Sensing.Sensor

    @valid_attrs %{name: "some name", type: "fake"}
    @invalid_attrs %{name: nil, type: nil}

    def sensor_fixture(attrs \\ %{}) do
      insert(:fake_sensor, attrs)
    end

    test "list_sensors/0 returns all sensors" do
      sensor = sensor_fixture()
      assert Sensing.list_sensors() == [sensor]
    end

    test "get_sensor!/1 returns the sensor with given id" do
      sensor = sensor_fixture()
      assert Sensing.get_sensor!(sensor.id) == sensor
    end

    test "create_sensor/1 with valid data creates a sensor" do
      assert {:ok, %Sensor{} = sensor} = Sensing.create_sensor(@valid_attrs)
      assert sensor.name == "some name"
      assert sensor.type == "fake"
    end

    test "create_sensor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sensing.create_sensor(@invalid_attrs)
    end

    test "create_sensor/1 with gpio id set" do
      gpio = insert(:gpio)
      attrs = Map.merge(@valid_attrs, %{gpio_id: gpio.id})

      assert {:ok, %Sensor{} = sensor} = Sensing.create_sensor(attrs)
      sensor = Repo.preload(sensor, :gpio)

      assert(sensor.gpio.name == gpio.name)
    end

    test "create_sensor/1 initializes the sensor process" do
      Application.put_env(:magic_home, :sensors_enabled, true)

      initial_sensors = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor))

      Sensing.create_sensor(@valid_attrs)

      sensors_count = initial_sensors + 1

      assert(
        ^sensors_count = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor))
      )

      MagicHome.TestTools.reset_magic_home_state()
      MagicHome.TestTools.reset_bpm_state()
    end

    test "update_sensor/2 with valid data updates the sensor" do
      update_attrs = params_for(:gpio_sensor)
      sensor = sensor_fixture()
      assert {:ok, %Sensor{} = sensor} = Sensing.update_sensor(sensor, update_attrs)
      assert sensor.name == update_attrs[:name]
      assert sensor.type == update_attrs[:type]
      assert sensor.gpio_id == update_attrs[:gpio_id]
    end

    test "update_sensor/2 for gpio_sensor without gpio_id returns error changeset" do
      invalid_attrs = params_for(:gpio_sensor) |> Map.delete(:gpio_id)
      sensor = sensor_fixture()
      assert {:error, %Ecto.Changeset{}} = Sensing.update_sensor(sensor, invalid_attrs)
      assert sensor == Sensing.get_sensor!(sensor.id)
    end

    test "update_sensor/2 with invalid data returns error changeset" do
      sensor = sensor_fixture()
      assert {:error, %Ecto.Changeset{}} = Sensing.update_sensor(sensor, @invalid_attrs)
      assert sensor == Sensing.get_sensor!(sensor.id)
    end

    test "delete_sensor/1 deletes the sensor" do
      sensor = sensor_fixture()
      assert {:ok, %Sensor{}} = Sensing.delete_sensor(sensor)
      assert_raise Ecto.NoResultsError, fn -> Sensing.get_sensor!(sensor.id) end
    end

    test "delete_sensor/1 terminates the sensor process" do
      Application.put_env(:magic_home, :sensors_enabled, true)

      {:ok, sensor} = Sensing.create_sensor(@valid_attrs)

      initial_sensors = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor))

      assert {:ok, %Sensor{}} = Sensing.delete_sensor(sensor)

      sensors_count = initial_sensors - 1

      assert(
        ^sensors_count = Enum.count(Supervisor.which_children(MagicHome.Sensing.SensorSupervisor))
      )

      MagicHome.TestTools.reset_magic_home_state()
      MagicHome.TestTools.reset_bpm_state()
    end

    test "change_sensor/1 returns a sensor changeset" do
      sensor = sensor_fixture()
      assert %Ecto.Changeset{} = Sensing.change_sensor(sensor)
    end
  end
end
