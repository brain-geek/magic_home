defmodule MagicHome.Lights.LampProcessTest do
  use MagicHome.DataCase

  setup do
    Application.put_env(:magic_home, :lamps_enabled, true)
    MagicHome.TestTools.reset_magic_home_state()
  end

  test "status/1 allows checking lamp status" do
    lamp = insert(:fake_lamp)
    MagicHome.Lights.LampManager.start(lamp.id)

    assert(:off = MagicHome.Lights.LampProcess.status(lamp.id))
    assert(:off = MagicHome.Lights.LampProcess.status(lamp))
  end

  test "light_up/1 lights the lamp up" do
    lamp = insert(:fake_lamp)
    MagicHome.Lights.LampManager.start(lamp)

    MagicHome.Lights.LampProcess.light_up(lamp)
    assert(:on = MagicHome.Lights.LampProcess.status(lamp))

    MagicHome.Lights.LampProcess.light_up(lamp)
    assert(:on = MagicHome.Lights.LampProcess.status(lamp))
  end

  test "light_down/1 disables the lamp" do
    lamp = insert(:fake_lamp)
    MagicHome.Lights.LampManager.start(lamp)
    MagicHome.Lights.LampProcess.light_up(lamp)
    assert(:on = MagicHome.Lights.LampProcess.status(lamp))

    MagicHome.Lights.LampProcess.light_down(lamp)
    assert(:off = MagicHome.Lights.LampProcess.status(lamp))

    MagicHome.Lights.LampProcess.light_down(lamp)
    assert(:off = MagicHome.Lights.LampProcess.status(lamp))
  end

  test "light_toggle/1 toggles lamp state when requested" do
    lamp = insert(:fake_lamp)
    MagicHome.Lights.LampManager.start(lamp)

    MagicHome.Lights.LampProcess.light_toggle(lamp)
    assert(:on = MagicHome.Lights.LampProcess.status(lamp))

    MagicHome.Lights.LampProcess.light_toggle(lamp)
    assert(:off = MagicHome.Lights.LampProcess.status(lamp))

    MagicHome.Lights.LampProcess.light_toggle(lamp)
    assert(:on = MagicHome.Lights.LampProcess.status(lamp))
  end
end
