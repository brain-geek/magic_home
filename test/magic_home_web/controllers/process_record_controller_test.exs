defmodule MagicHomeWeb.ProcessRecordControllerTest do
  use MagicHomeWeb.ConnCase

  @minimal_valid_bpmn """
  <?xml version="1.0" encoding="UTF-8"?>
  <definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" targetNamespace="" xsi:schemaLocation="http://www.omg.org/spec/BPMN/20100524/MODEL http://www.omg.org/spec/BPMN/2.0/20100501/BPMN20.xsd">
    <collaboration id="Collaboration_0cyykem">
      <participant id="Participant_1ckdn91" name="Test tiny process" processRef="Process_1nm1w9v" />
    </collaboration>
    <process id="Process_1nm1w9v" />
    <bpmndi:BPMNDiagram id="sid-74620812-92c4-44e5-949c-aa47393d3830">
      <bpmndi:BPMNPlane id="sid-cdcae759-2af7-4a6d-bd02-53f3352a731d" bpmnElement="Collaboration_0cyykem">
        <bpmndi:BPMNShape id="Participant_1ckdn91_di" bpmnElement="Participant_1ckdn91">
          <omgdc:Bounds x="58.06342780026989" y="335.02834008097165" width="600" height="250" />
        </bpmndi:BPMNShape>
      </bpmndi:BPMNPlane>
      <bpmndi:BPMNLabelStyle id="sid-e0502d32-f8d1-41cf-9c4a-cbb49fecf581">
        <omgdc:Font name="Arial" size="11" isBold="false" isItalic="false" isUnderline="false" isStrikeThrough="false" />
      </bpmndi:BPMNLabelStyle>
      <bpmndi:BPMNLabelStyle id="sid-84cb49fd-2f7c-44fb-8950-83c3fa153d3b">
        <omgdc:Font name="Arial" size="12" isBold="false" isItalic="false" isUnderline="false" isStrikeThrough="false" />
      </bpmndi:BPMNLabelStyle>
    </bpmndi:BPMNDiagram>
  </definitions>
  """

  @create_attrs %{active: true, body: @minimal_valid_bpmn, title: "some title"}
  @update_attrs %{active: false, body: @minimal_valid_bpmn, title: "some updated title"}
  @invalid_attrs %{active: nil, body: nil, title: nil}

  describe "index" do
    test "lists all process_records", %{conn: conn} do
      conn = get(conn, Routes.process_record_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Process records"
    end
  end

  describe "new process_record" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.process_record_path(conn, :new))
      assert html_response(conn, 200) =~ "New Process record"
    end
  end

  describe "create process_record" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.process_record_path(conn, :create), process_record: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.process_record_path(conn, :show, id)

      conn = get(conn, Routes.process_record_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Process record"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.process_record_path(conn, :create), process_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Process record"
    end
  end

  describe "edit process_record" do
    setup [:create_process_record]

    test "renders form for editing chosen process_record", %{
      conn: conn,
      process_record: process_record
    } do
      conn = get(conn, Routes.process_record_path(conn, :edit, process_record))
      assert html_response(conn, 200) =~ "Edit Process record"
    end
  end

  describe "update process_record" do
    setup [:create_process_record]

    test "redirects when data is valid", %{conn: conn, process_record: process_record} do
      conn =
        put(conn, Routes.process_record_path(conn, :update, process_record),
          process_record: @update_attrs
        )

      assert redirected_to(conn) == Routes.process_record_path(conn, :show, process_record)

      conn = get(conn, Routes.process_record_path(conn, :show, process_record))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, process_record: process_record} do
      conn =
        put(conn, Routes.process_record_path(conn, :update, process_record),
          process_record: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Process record"
    end
  end

  describe "delete process_record" do
    setup [:create_process_record]

    test "deletes chosen process_record", %{conn: conn, process_record: process_record} do
      conn = delete(conn, Routes.process_record_path(conn, :delete, process_record))
      assert redirected_to(conn) == Routes.process_record_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.process_record_path(conn, :show, process_record))
      end)
    end
  end

  defp create_process_record(_) do
    {:ok, process_record: insert(:process)}
  end
end
