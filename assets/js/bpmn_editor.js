import BpmnModeler from 'bpmn-js/dist/bpmn-modeler.development.js'

document.addEventListener("DOMContentLoaded",function(){
  var form_element = document.getElementById('process_record_body')
  var canvas_selector = '#bpm_canvas'

  if(!form_element){ return }

  // modeler instance
  var bpmnModeler = new BpmnModeler({
    container: canvas_selector,
    keyboard: {
      bindTo: window
    }
  });

  /**
   * Save diagram contents and print them to the console.
   */
  function exportDiagram() {
    bpmnModeler.saveXML({ format: true }, function(err, xml) {
      if (err) {
        return console.error('could not save BPMN 2.0 diagram', err);
      }
      alert('Diagram exported. Check the developer tools!');
      console.log(xml);
    });
  }

  window.exportDiagram = exportDiagram

  var exportButton = document.getElementById('bpmnExportButton')
  exportButton.addEventListener('click', exportDiagram, false)


  /**
   * Open diagram in our modeler instance.
   *
   * @param {String} bpmnXML diagram to display
   */
  function openDiagram(bpmnXML) {
    // import diagram
    bpmnModeler.importXML(bpmnXML, function(err) {
      if (err) {
        return console.error('could not import BPMN 2.0 diagram', err);
      }
      // access modeler components
      var canvas = bpmnModeler.get('canvas');

      // zoom to fit full viewport
      canvas.zoom('fit-viewport', 'auto');
    });
  }

  function htmlDecode(input) {
    var doc = new DOMParser().parseFromString(input, "text/html");
    return doc.documentElement.textContent;
  }

  if (form_element.value == '') {
    let basic_bpmn = `
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" targetNamespace="" xsi:schemaLocation="http://www.omg.org/spec/BPMN/20100524/MODEL http://www.omg.org/spec/BPMN/2.0/20100501/BPMN20.xsd">
  <process id="{{PROCESS_ID}}">
    <startEvent id="{{PROCESS_ID}}_StartEvent" />
  </process>
  <bpmndi:BPMNDiagram>
    <bpmndi:BPMNPlane bpmnElement="{{PROCESS_ID}}">
      <bpmndi:BPMNShape id="StartEvent_1kh4mpv_di" bpmnElement="{{PROCESS_ID}_StartEvent">
        <omgdc:Bounds x="300" y="300" width="36" height="36" />
      </bpmndi:BPMNShape>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</definitions>
`

    let uniqueId = Math.random().toString(36).substring(2) + (new Date()).getTime().toString(36);

    openDiagram(basic_bpmn.replace("{{PROCESS_ID}}", uniqueId));
  } else {
    openDiagram(form_element.value);
  }

  /**
   * Importing diagram
   */

  let importInput  = document.getElementById('bpmnImportArea')
  var importButton = document.getElementById('bpmnImportButton')
  importButton.addEventListener('click', function() {
    let body = document.getElementById('bpmnImportArea').value
    openDiagram(body)
  }, false)

  /**
   * Before form submit, export BPM from the editor and persist it.
   */

  document.querySelector("#bpm_form").addEventListener("submit", function(e){
    bpmnModeler.saveXML({ format: true }, function(err, xml) {
      if (err) {
        console.log(err)
      } else {
        form_element.value = xml;
        document.querySelector("#bpm_form").submit();
      }
    });

    e.preventDefault();
  })
})
