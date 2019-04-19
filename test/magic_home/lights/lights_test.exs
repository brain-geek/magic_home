defmodule MagicHome.LightsTest do
  use MagicHome.DataCase

  alias MagicHome.Lights

  describe "lamps" do
    alias MagicHome.Lights.Lamp

    @valid_attrs %{name: "some name", type: "fake"}
    @invalid_attrs %{name: nil, type: nil}

    def lamp_fixture(attrs \\ %{}) do
      insert(:fake_lamp, attrs)
    end

    test "list_lamps/0 returns all lamps" do
      lamp = lamp_fixture()
      assert Lights.list_lamps() == [lamp]
    end

    test "get_lamp!/1 returns the lamp with given id" do
      lamp = lamp_fixture()
      assert Lights.get_lamp!(lamp.id) == lamp
    end

    test "create_lamp/1 with valid data creates a lamp" do
      assert {:ok, %Lamp{} = lamp} = Lights.create_lamp(@valid_attrs)
      assert lamp.name == "some name"
      assert lamp.type == "fake"
    end

    test "create_lamp/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lights.create_lamp(@invalid_attrs)
    end

    test "create_lamp/1 initializes the lamp process" do
      Application.put_env(:magic_home, :lamps_enabled, true)

      initial_lamps = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor))

      Lights.create_lamp(@valid_attrs)

      lamps_count = initial_lamps + 1

      assert(
        ^lamps_count = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor))
      )

      MagicHome.TestTools.reset_magic_home_state()
      MagicHome.TestTools.reset_bpm_state()
    end

    test "create_lamp/1 with gpio id set" do
      gpio = insert(:gpio)
      attrs = Map.merge(@valid_attrs, %{gpio_id: gpio.id})

      assert {:ok, %Lamp{} = lamp} = Lights.create_lamp(attrs)
      lamp = Repo.preload(lamp, :gpio)

      assert(lamp.gpio.name == gpio.name)
    end

    test "update_lamp/2 with valid data updates the lamp" do
      update_attrs = params_for(:gpio_lamp)
      lamp = lamp_fixture()
      assert {:ok, %Lamp{} = lamp} = Lights.update_lamp(lamp, update_attrs)
      assert lamp.name == update_attrs[:name]
      assert lamp.type == update_attrs[:type]
      assert lamp.gpio_id == update_attrs[:gpio_id]
    end

    test "update_lamp/2 without gpio_id returns error changeset" do
      invalid_attrs = params_for(:gpio_lamp) |> Map.delete(:gpio_id)
      lamp = lamp_fixture()
      assert {:error, %Ecto.Changeset{}} = Lights.update_lamp(lamp, invalid_attrs)
      assert lamp == Lights.get_lamp!(lamp.id)
    end

    test "update_lamp/2 with invalid data returns error changeset" do
      lamp = lamp_fixture()
      assert {:error, %Ecto.Changeset{}} = Lights.update_lamp(lamp, @invalid_attrs)
      assert lamp == Lights.get_lamp!(lamp.id)
    end

    test "delete_lamp/1 deletes the lamp" do
      lamp = lamp_fixture()
      assert {:ok, %Lamp{}} = Lights.delete_lamp(lamp)
      assert_raise Ecto.NoResultsError, fn -> Lights.get_lamp!(lamp.id) end
    end

    test "delete_lamp/1 terminates the lamp process" do
      Application.put_env(:magic_home, :lamps_enabled, true)

      {:ok, lamp} = Lights.create_lamp(@valid_attrs)

      initial_lamps = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor))

      assert {:ok, %Lamp{}} = Lights.delete_lamp(lamp)

      lamps_count = initial_lamps - 1

      assert(
        ^lamps_count = Enum.count(Supervisor.which_children(MagicHome.Lights.LampSupervisor))
      )

      MagicHome.TestTools.reset_magic_home_state()
      MagicHome.TestTools.reset_bpm_state()
    end

    test "change_lamp/1 returns a lamp changeset" do
      lamp = lamp_fixture()
      assert %Ecto.Changeset{} = Lights.change_lamp(lamp)
    end
  end
end
