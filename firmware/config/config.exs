# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger, :console]
config :logger, level: :debug

config :logger,
  backends: [:console],
  compile_time_purge_level: :debug

# Our Console Backend-specific configuration
config :logger, :console,
  format: "\n##### $time $metadata[$level] $levelpad$message\n",
  metadata: :all

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
node_name = if Mix.env() != :prod, do: "firmware"

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: node_name,
  node_host: :mdns_domain

import_config "../../config/config.exs" # Basic phoenix configuration

# Endpoint config
config :magic_home, MagicHomeWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "GooThgbn9kdUOcHJY401nNs84g64pnHZ/zyIrkBrsE6JDRYo4ctRRV+9OXDn0PY5",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: MagicHomeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

# Repo
config :magic_home, MagicHome.Repo,
  adapter: Sqlite.Ecto2,
  database: "/root/magic_home-#{Mix.env}.sqlite3"

# Import device specific config
device_name = System.get_env("DEVICE")
if device_name do
  import_config "devices/#{device_name}.exs"
end

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"

