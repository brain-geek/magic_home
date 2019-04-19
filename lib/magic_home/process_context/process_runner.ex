defmodule MagicHome.ProcessContext.ProcessRunner do
  use GenServer

  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_params) do
    {:ok, %{}}
  end
end
