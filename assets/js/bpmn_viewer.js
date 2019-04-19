import BpmnViewer from 'bpmn-js/dist/bpmn-viewer.development.js'

document.addEventListener("DOMContentLoaded",function(){
  var form_element = document.getElementById('bpmn_viewer_data')
  var canvas_selector = '#bpm_canvas'

  if(!form_element){ return }

  var bpmnViewer = new BpmnViewer({ container: canvas_selector });

  /**
   * Open diagram in our modeler instance.
   *
   * @param {String} bpmnXML diagram to display
   */
  function openDiagram(bpmnXML) {
    // import diagram
    bpmnViewer.importXML(bpmnXML, function(err) {
      if (err) {
        return console.error('could not import BPMN 2.0 diagram', err);
      }
      // access modeler components
      var canvas = bpmnViewer.get('canvas');

      // zoom to fit full viewport
      canvas.zoom('fit-viewport', 'auto');

      var dimensions = canvas.viewbox();
    });
  }

  openDiagram(form_element.value);
})
