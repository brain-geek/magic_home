# Magic Home

Magic home is a project aimed to build a complete solution for smart home powered by Elixir.

While a lot of solutions are present in the market, they usually don't offer much flexibility or require costly proprietary hardware.

It is an entirely self-hosted solution. You can build supported hardware from the off-the-shelf components available everywhere in the world.

## Setting up development environment

  * Clone project
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

  Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Creating a Magic Home firmware

#### Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

#### Devices

Similar to Targets, Magic home requires `DEVICE` environment variable set to
specify which device you are going to burn. You can use `example` provided by default.

#### Burning the image

To start your Nerves app:
  * Go to `firmware` directory
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * `export DEVICE=example` or prefix every command with
    `DEVICE=example`. For example, `DEVICE=example`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn` or use `./upload.sh my_ip` if your device has network connection

