defmodule MagicHome.Sensing.SensorProcessGeneric do
  defmacro __using__(_params) do
    quote do
      @process_registry MagicHome.Sensing.SensorRegistry

      alias MagicHome.Sensing.Sensor

      @doc false
      def registry_pid_key(pid) do
        {:pid, pid}
      end

      @doc false
      def registry_name_key(id) do
        {:sensor_id, id}
      end

      @doc false
      def process_name(lamp_id) do
        :"sensor:#{lamp_id}"
      end
    end
  end
end
