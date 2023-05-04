import 'dart:math' as math;

import 'package:diagram/hierarchical_example/policy/custom_policy.dart';
import 'package:diagram/simple_diagram_editor/data/custom_component_data.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  var sizes = [
    const Size(80, 60),
    const Size(200, 150),
  ];

  @override
  onCanvasTapUp(TapUpDetails details) {
    canvasWriter.model.hideAllLinkJoints();

    if (isReadyToAddParent) {
      isReadyToAddParent = false;
      canvasWriter.model.updateComponent(selectedComponentId);
    } else {
      if (selectedComponentId.isNotEmpty) {
        hideComponentHighlight(selectedComponentId);
        selectedComponentId = '';
      } else {
        canvasWriter.model.addComponent(
          ComponentData(
            size: sizes[math.Random().nextInt(sizes.length)],
            minSize: const Size(72, 48),
            position: canvasReader.state.fromCanvasCoordinates(details.localPosition),
            data: MyComponentData(),
          ),
        );
      }
    }
  }
}
