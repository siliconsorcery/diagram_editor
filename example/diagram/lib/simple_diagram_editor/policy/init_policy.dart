import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` MyInitPolicy
mixin MyInitPolicy implements InitPolicy {
  // q` > initializeDiagramEditor
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setCanvasColor(Colors.grey[300]!);
  }
}
