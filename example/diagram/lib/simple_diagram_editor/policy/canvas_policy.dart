import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';

// q` MyCanvasPolicy
mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  // q` > onCanvasTap
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect) {
      isReadyToConnect = false;
      if (selectedComponentId != null) {
        canvasWriter.model.updateComponent(selectedComponentId!);
      }
    } else {
      selectedComponentId = null;
      hideAllHighlights();
    }
  }
}
