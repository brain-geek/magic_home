defmodule MagicHome.ProcessContext.ProcessExecutorBehavior do
  @callback run(String.t(), String.t()) :: {:ok, term} | {:error, String.t()}
  @callback terminate(String.t()) :: {:ok, term} | {:error, String.t()}
end
