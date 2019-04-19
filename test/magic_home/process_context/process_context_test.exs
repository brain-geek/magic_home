defmodule MagicHome.ProcessContextTest do
  use MagicHome.DataCase

  alias MagicHome.ProcessContext

  setup do
    MagicHome.TestTools.reset_bpm_state()
  end

  describe "process_records" do
    alias MagicHome.ProcessContext.ProcessRecord

    @invalid_attrs %{active: nil, body: nil, title: nil}
    @broken_bpmn """
      <?xml version="1.0" encoding="UTF-8"?>
      <definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" targetNamespace="" xsi:schemaLocation="http://www.omg.org/spec/BPMN/20100524/MODEL http://www.omg.org/spec/BPMN/2.0/20100501/BPMN20.xsd">
      </definitions>
    """

    def process_record_fixture(attrs \\ %{}) do
      insert(:process, attrs)
    end

    test "list_process_records/0 returns all process_records" do
      process_record = insert(:process)
      assert ProcessContext.list_process_records() == [process_record]
    end

    test "get_process_record!/1 returns the process_record with given id" do
      process_record = process_record_fixture()
      assert ProcessContext.get_process_record!(process_record.id) == process_record
    end

    test "create_process_record/1 with valid data creates a process_record" do
      valid_attrs = params_for(:process)

      assert {:ok, %ProcessRecord{} = process_record} =
               ProcessContext.create_process_record(valid_attrs)

      assert process_record.active == true
      assert process_record.body == valid_attrs.body
      assert process_record.title == valid_attrs.title

      # Check whether the BPM process has started
      pr_id = process_record.id

      assert(
        [
          {_, ^pr_id}
        ] = ExProcess.RunnerProcess.list_running()
      )
    end

    test "create_process_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProcessContext.create_process_record(@invalid_attrs)
    end

    test "create_process_record/1 when bpmn is broken" do
      broken_bpmn_attrs = Map.merge(params_for(:process), %{body: @broken_bpmn})
      assert {:error, %Ecto.Changeset{}} = ProcessContext.create_process_record(broken_bpmn_attrs)
    end

    test "update_process_record/2 with valid data updates the process_record" do
      process_record = process_record_fixture()

      assert {:ok, %ProcessRecord{} = process_record} =
               ProcessContext.update_process_record(process_record, %{
                 active: false,
                 title: "some updated title"
               })

      assert process_record.active == false
      assert process_record.title == "some updated title"
    end

    test "update_process_record/2 with %{active: false} attribute shuts down the process" do
      valid_attrs = params_for(:process)

      assert {:ok, process_record} = ProcessContext.create_process_record(valid_attrs)

      pr_id = process_record.id

      assert(
        [
          {_, ^pr_id}
        ] = ExProcess.RunnerProcess.list_running()
      )

      ProcessContext.update_process_record(process_record, %{
        active: false
      })

      assert(Enum.empty?(ExProcess.RunnerProcess.list_running()))
    end

    test "update_process_record/2 with %{active: true} attribute restarts the process" do
      # TODO: add a check that process is actually restarted, not just starting
      process_record = process_record_fixture()

      pr_id = process_record.id

      assert(Enum.empty?(ExProcess.RunnerProcess.list_running()))

      assert {:ok, process_record} =
               ProcessContext.update_process_record(process_record, %{
                 active: true
               })

      assert(
        [
          {_, ^pr_id}
        ] = ExProcess.RunnerProcess.list_running()
      )
    end

    test "update_process_record/2 with invalid data returns error changeset" do
      process_record = process_record_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ProcessContext.update_process_record(process_record, @invalid_attrs)

      assert process_record == ProcessContext.get_process_record!(process_record.id)
    end

    test "delete_process_record/1 deletes the process_record" do
      process_record = process_record_fixture()
      assert {:ok, %ProcessRecord{}} = ProcessContext.delete_process_record(process_record)

      assert_raise Ecto.NoResultsError, fn ->
        ProcessContext.get_process_record!(process_record.id)
      end
    end

    test "delete_process_record/1 stops the corresponding process" do
      valid_attrs = params_for(:process)

      assert {:ok, process_record} = ProcessContext.create_process_record(valid_attrs)

      pr_id = process_record.id

      assert(
        [
          {_, ^pr_id}
        ] = ExProcess.RunnerProcess.list_running()
      )

      assert ProcessContext.delete_process_record(process_record)

      assert(Enum.empty?(ExProcess.RunnerProcess.list_running()))
    end

    test "change_process_record/1 returns a process_record changeset" do
      process_record = process_record_fixture()
      assert %Ecto.Changeset{} = ProcessContext.change_process_record(process_record)
    end
  end
end
