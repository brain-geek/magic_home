defmodule MagicHome.ProcessContext.ProcessRunner do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    GenServer.cast(self(), :run_all)

    {:ok, nil}
  end

  @doc false
  def handle_cast(:run_all, state) do
    MagicHome.ProcessContext.list_process_records()
      |> Enum.each(&(Application.get_env(:magic_home, :bpm_executor).run(&1.id, &1.body)))

    {:noreply, state}
  end

end
