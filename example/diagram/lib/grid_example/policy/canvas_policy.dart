import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) async {
    final width = math.Random().nextInt(160) + 80.0;
    final height = math.Random().nextInt(160) + 80.0;

    canvasWriter.model.addComponent(
      ComponentData(
        size: Size(width, height),
        position: canvasReader.state.fromCanvasCoordinates(details.localPosition) - Offset(width / 2, height / 2),
      ),
    );
  }
}
