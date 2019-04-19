defmodule MagicHome.Lights.LampProcessGeneric do
  defmacro __using__(_params) do
    quote do
      @process_registry MagicHome.Lights.LampRegistry

      alias MagicHome.Lights.Lamp

      @doc false
      def registry_pid_key(pid) do
        {:pid, pid}
      end

      @doc false
      def registry_name_key(id) do
        {:lamp_id, id}
      end

      @doc false
      def process_name(lamp_id) do
        :"lamp:#{lamp_id}"
      end
    end
  end
end
