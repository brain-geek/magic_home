defmodule MagicHome.ProcessContext.ProcessRecord do
  use MagicHome.Schema
  import Ecto.Changeset

  schema "process_records" do
    field(:active, :boolean, default: false)
    field(:body, :string)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(process_record, attrs) do
    process_record
    |> cast(attrs, [:title, :body, :active])
    |> validate_required([:title, :body, :active])
    |> validate_bpm_process(:body)
  end

  @doc false
  def validate_bpm_process(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, bpm_body ->
      case ExProcess.Bpmn.Parser.parse(bpm_body) do
        {:ok, parsed_bpmn} ->
          is_valid = ExProcess.Verifier.check(parsed_bpmn)

          case is_valid do
            :ok -> []
            _ -> [{field, options[:message] || "Expected valid BPMN"}]
          end

        _ ->
          [{field, options[:message] || "BPMN expected"}]
      end
    end)
  end
end
