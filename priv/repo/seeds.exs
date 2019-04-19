# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MagicHome.Repo.insert!(%MagicHome.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MagicHome.Repo

Repo.insert %MagicHome.Hardware.Gpio{
    id: "dbe486cc-de7f-4505-b3fc-6e79dc8d4d00",
    name: "Switch GPIO",
    number: 26,
    type: "input",
  }

Repo.insert %MagicHome.Hardware.Gpio{
    id: "749442dd-236a-4369-bcf1-d0de4c5160e5",
    name: "Lamp GPIO",
    number: 16,
    type: "output",
  }

Repo.insert %MagicHome.Lights.Lamp{
    gpio_id: "749442dd-236a-4369-bcf1-d0de4c5160e5",
    id: "65baa9db-0c48-401c-a359-f403ad48c096",
    name: "Test lamp",
    type: "gpio",
  }

Repo.insert %MagicHome.Sensing.Sensor{
    gpio_id: "dbe486cc-de7f-4505-b3fc-6e79dc8d4d00",
    id: "d86236fd-bddc-492c-948b-ab02f2ec2463",
    name: "Test sensor",
    type: "gpio_switch",
  }

Repo.insert %MagicHome.ProcessContext.ProcessRecord{
    active: true,
    body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<definitions xmlns=\"http://www.omg.org/spec/BPMN/20100524/MODEL\" xmlns:bpmndi=\"http://www.omg.org/spec/BPMN/20100524/DI\" xmlns:omgdc=\"http://www.omg.org/spec/DD/20100524/DC\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:di=\"http://www.omg.org/spec/DD/20100524/DI\" targetNamespace=\"\" xsi:schemaLocation=\"http://www.omg.org/spec/BPMN/20100524/MODEL http://www.omg.org/spec/BPMN/2.0/20100501/BPMN20.xsd\">\r\n  <process id=\"xuhfq53mudljuokn4ve\">\r\n    <startEvent id=\"{{PROCESS_ID}}_StartEvent\" />\r\n    <intermediateThrowEvent id=\"IntermediateThrowEvent_1g71wsg\" name=\"Test sensor was triggered\">\r\n      <outgoing>SequenceFlow_1p1o8o2</outgoing>\r\n    </intermediateThrowEvent>\r\n    <task id=\"Task_13hne4x\" name=\"Toggle light Test lamp\">\r\n      <incoming>SequenceFlow_1p1o8o2</incoming>\r\n    </task>\r\n    <sequenceFlow id=\"SequenceFlow_1p1o8o2\" sourceRef=\"IntermediateThrowEvent_1g71wsg\" targetRef=\"Task_13hne4x\" />\r\n  </process>\r\n  <bpmndi:BPMNDiagram>\r\n    <bpmndi:BPMNPlane bpmnElement=\"xuhfq53mudljuokn4ve\">\r\n      <bpmndi:BPMNShape id=\"StartEvent_1kh4mpv_di\">\r\n        <omgdc:Bounds x=\"300\" y=\"300\" width=\"36\" height=\"36\" />\r\n      </bpmndi:BPMNShape>\r\n      <bpmndi:BPMNShape id=\"IntermediateThrowEvent_1g71wsg_di\" bpmnElement=\"IntermediateThrowEvent_1g71wsg\">\r\n        <omgdc:Bounds x=\"-293\" y=\"-98\" width=\"36\" height=\"36\" />\r\n        <bpmndi:BPMNLabel>\r\n          <omgdc:Bounds x=\"-307\" y=\"-55\" width=\"65\" height=\"27\" />\r\n        </bpmndi:BPMNLabel>\r\n      </bpmndi:BPMNShape>\r\n      <bpmndi:BPMNShape id=\"Task_13hne4x_di\" bpmnElement=\"Task_13hne4x\">\r\n        <omgdc:Bounds x=\"-207\" y=\"-120\" width=\"100\" height=\"80\" />\r\n      </bpmndi:BPMNShape>\r\n      <bpmndi:BPMNEdge id=\"SequenceFlow_1p1o8o2_di\" bpmnElement=\"SequenceFlow_1p1o8o2\">\r\n        <di:waypoint x=\"-257\" y=\"-80\" />\r\n        <di:waypoint x=\"-207\" y=\"-80\" />\r\n      </bpmndi:BPMNEdge>\r\n    </bpmndi:BPMNPlane>\r\n  </bpmndi:BPMNDiagram>\r\n</definitions>\r\n",
    id: "4ca20019-c96e-49f3-90fa-e486eb36ff09",
    title: "Test process",
  }
