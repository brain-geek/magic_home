defmodule MagicHome.ProcessContext.ProcessExecutorExProcess do
  @behaviour MagicHome.ProcessContext.ProcessExecutorBehavior

  @impl MagicHome.ProcessContext.ProcessExecutorBehavior
  def run(name, bpm_body) do
    {:ok, process} = ExProcess.Bpmn.Parser.parse(bpm_body)
    ExProcess.ProcessSupervisor.run(process, %{process_name: name})
  end

  @impl MagicHome.ProcessContext.ProcessExecutorBehavior
  def terminate(name) do
    ExProcess.ProcessSupervisor.terminate(name)
  end
end
