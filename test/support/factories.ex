defmodule MagicHome.Factory do
  use ExMachina.Ecto, repo: MagicHome.Repo

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

  def process_factory do
    %MagicHome.ProcessContext.ProcessRecord{
      active: true,
      title: sequence(:title, &"Process #{&1}"),
      body: @minimal_valid_bpmn
    }
  end

  def gpio_factory do
    Enum.random([output_gpio_factory(), input_gpio_factory()])
  end

  def output_gpio_factory do
    %MagicHome.Hardware.Gpio{
      name: sequence(:hardware_name, &"Hardware GPIO #{&1}"),
      number: 42,
      type: "output"
    }
  end

  def input_gpio_factory do
    %MagicHome.Hardware.Gpio{
      name: sequence(:hardware_name, &"Hardware GPIO #{&1}"),
      number: 42,
      type: "input"
    }
  end

  def lamp_factory do
    Enum.random([fake_lamp_factory(), gpio_lamp_factory()])
  end

  def fake_lamp_factory do
    %MagicHome.Lights.Lamp{
      name: sequence(:lamp_name, &"Fake lamp #{&1}"),
      type: "fake"
    }
  end

  def gpio_lamp_factory do
    %MagicHome.Lights.Lamp{
      name: sequence(:lamp_name, &"Fake lamp #{&1}"),
      type: "gpio",
      gpio_id: insert(:gpio).id
    }
  end

  def sensor_factory do
    Enum.random([fake_sensor_factory(), gpio_sensor_factory()])
  end

  def fake_sensor_factory do
    %MagicHome.Sensing.Sensor{
      name: sequence(:sensor_name, &"Fake sensor #{&1}"),
      type: "fake"
    }
  end

  def gpio_sensor_factory do
    %MagicHome.Sensing.Sensor{
      name: sequence(:sensor_name, &"Sensor #{&1}"),
      type: "gpio_switch",
      gpio_id: insert(:gpio).id
    }
  end
end
