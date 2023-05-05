import 'dart:math' as math;

import 'package:diagram/complex_example/components/rainbow.dart';
import 'package:diagram/complex_example/components/random.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class MyComponentData {
  bool isHighlightVisible;
  Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  MyComponentData({
    this.isHighlightVisible = false,
  });

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyComponentDesignPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        CustomPolicy,
        MyLinkAttachmentPolicy,
        CanvasControlPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy {}

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setCanvasColor(Colors.grey[300]!);
  }
}

mixin MyComponentDesignPolicy implements ComponentDesignPolicy, CustomPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    switch (componentData.type) {
      case 'rainbow':
        return ComplexRainbowComponent(componentData: componentData);
      case 'random':
        return RandomComponent(componentData: componentData);
      case 'flutter':
        final isHilit = componentData.data.isHighlightVisible;
        return Container(
          decoration: BoxDecoration(
            color: isHilit ? const Color.fromARGB(0, 0, 0, 0) : Colors.limeAccent.withAlpha(128),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHilit ? Colors.lightBlue : Colors.limeAccent,
              width: 4,
            ),
          ),
          child: isHilit ? const FlutterLogo(style: FlutterLogoStyle.horizontal) : const FlutterLogo(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    hideComponentHighlight(selectedComponentId);
    selectedComponentId = '';
    canvasWriter.model.hideAllLinkJoints();

    canvasWriter.model.addComponent(
      ComponentData(
        size: const Size(400, 300),
        position: canvasReader.state.fromCanvasCoordinates(details.localPosition),
        data: MyComponentData(),
        type: ['rainbow', 'random', 'flutter'][math.Random().nextInt(3)],
      ),
    );
  }
}

mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  Offset lastFocalPoint = Offset.zero;

  @override
  onComponentTap(String componentId) {
    hideComponentHighlight(selectedComponentId);
    canvasWriter.model.hideAllLinkJoints();

    bool connected = connectComponents(selectedComponentId, componentId);
    if (connected) {
      selectedComponentId = '';
    } else {
      selectedComponentId = componentId;
      highlightComponent(componentId);
    }
  }

  @override
  onComponentLongPress(String componentId) {
    hideComponentHighlight(selectedComponentId);
    selectedComponentId = '';
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.removeComponent(componentId);
  }

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;

    canvasWriter.model.moveComponent(componentId, positionDelta);

    lastFocalPoint = details.localFocalPoint;
  }

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == '') {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    // test if the connection between two components already exists (one way)
    if (canvasReader.model
        .getComponent(sourceComponentId)
        .connections
        .any((connection) => (connection is ConnectionOut) && (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 4,
        backArrowType: ArrowType.centerCircle,
        color: const Color.fromARGB(255, 128, 128, 128),
        arrowSize: 12,
        backArrowSize: 12,
        lineType: LineType.dashed,
      ),
    );

    return true;
  }
}

mixin CustomPolicy implements PolicySet {
  String selectedComponentId = '';

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).data.showHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
  }

  hideComponentHighlight(String componentId) {
    if (selectedComponentId.isNotEmpty) {
      canvasReader.model.getComponent(componentId).data.hideHighlight();
      canvasReader.model.getComponent(componentId).updateComponent();
    }
  }

  deleteAllComponents() {
    selectedComponentId = '';
    canvasWriter.model.removeAllComponents();
  }
}

mixin MyLinkAttachmentPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentData componentData,
    Offset targetPoint,
  ) {
    Offset pointPosition = targetPoint - (componentData.position + componentData.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    switch (componentData.type) {
      case 'random':
        return Alignment.center;

      case 'flutter':
        return const Alignment(-0.54, 0);

      default:
        Offset pointAlignment;
        if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
          pointAlignment = Offset(pointPosition.dx / pointPosition.dx.abs(), pointPosition.dy / pointPosition.dx.abs());
        } else {
          pointAlignment = Offset(pointPosition.dx / pointPosition.dy.abs(), pointPosition.dy / pointPosition.dy.abs());
        }
        return Alignment(pointAlignment.dx, pointAlignment.dy);
    }
  }
}
