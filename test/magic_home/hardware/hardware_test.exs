defmodule MagicHome.HardwareTest do
  use MagicHome.DataCase

  alias MagicHome.Hardware

  describe "gpios" do
    alias MagicHome.Hardware.Gpio

    @valid_attrs %{name: "some name", number: 42, type: "input"}
    @update_attrs %{name: "some updated name", number: 43, type: "output"}
    @invalid_attrs %{name: nil, number: nil, type: nil}

    def gpio_fixture(attrs \\ %{}) do
      insert(:gpio, attrs)
    end

    test "list_gpios/0 returns all gpios" do
      gpio = gpio_fixture()
      assert Hardware.list_gpios() == [gpio]
    end

    test "get_gpio!/1 returns the gpio with given id" do
      gpio = gpio_fixture()
      assert Hardware.get_gpio!(gpio.id) == gpio
    end

    test "create_gpio/1 with valid data creates a gpio" do
      assert {:ok, %Gpio{} = gpio} = Hardware.create_gpio(@valid_attrs)
      assert gpio.name == "some name"
      assert gpio.number == 42
      assert gpio.type == "input"
    end

    test "create_gpio/1 with input type creates a gpio" do
      assert {:ok, %Gpio{type: "input"} = gpio} =
               Hardware.create_gpio(params_for(:gpio, %{type: "input"}))
    end

    test "create_gpio/1 with output type creates a gpio" do
      assert {:ok, %Gpio{type: "output"} = gpio} =
               Hardware.create_gpio(params_for(:gpio, %{type: "output"}))
    end

    test "create_gpio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hardware.create_gpio(@invalid_attrs)
    end

    test "create_gpio/1 with non-standard type returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Hardware.create_gpio(params_for(:gpio, %{type: "other"}))
    end

    test "update_gpio/2 with valid data updates the gpio" do
      gpio = gpio_fixture()
      assert {:ok, %Gpio{} = gpio} = Hardware.update_gpio(gpio, @update_attrs)
      assert gpio.name == "some updated name"
      assert gpio.number == 43
      assert gpio.type == "output"
    end

    test "update_gpio/2 with invalid data returns error changeset" do
      gpio = gpio_fixture()
      assert {:error, %Ecto.Changeset{}} = Hardware.update_gpio(gpio, @invalid_attrs)
      assert gpio == Hardware.get_gpio!(gpio.id)
    end

    test "delete_gpio/1 deletes the gpio" do
      gpio = gpio_fixture()
      assert {:ok, %Gpio{}} = Hardware.delete_gpio(gpio)
      assert_raise Ecto.NoResultsError, fn -> Hardware.get_gpio!(gpio.id) end
    end

    test "change_gpio/1 returns a gpio changeset" do
      gpio = gpio_fixture()
      assert %Ecto.Changeset{} = Hardware.change_gpio(gpio)
    end
  end
end
