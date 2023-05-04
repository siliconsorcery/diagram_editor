import 'package:diagram/simple_diagram_editor/data/custom_component_data.dart';
import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyCanvasWidgetsPolicy implements CanvasWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showCustomWidgetsOnCanvasBackground(BuildContext context) {
    return [
      Visibility(
        visible: isGridVisible,
        child: CustomPaint(
          size: Size.infinite,
          painter: GridPainter(
            offset: canvasReader.state.position / canvasReader.state.scale,
            scale: canvasReader.state.scale,
            lineWidth: (canvasReader.state.scale < 1.0) ? canvasReader.state.scale : 1.0,
            matchParentSize: false,
            lineColor: Colors.blue[900]!,
          ),
        ),
      ),
      DragTarget<ComponentData>(
        builder: (_, __, ___) => const SizedBox(),
        onWillAccept: (data) => true,
        onAcceptWithDetails: (details) => _onAcceptWithDetails(details, context),
      ),
    ];
  }

  _onAcceptWithDetails(
    DragTargetDetails details,
    BuildContext context,
  ) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) return;
    final RenderBox renderBox = renderObject as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    ComponentData componentData = details.data;
    Offset componentPosition = canvasReader.state.fromCanvasCoordinates(localOffset);
    String componentId = canvasWriter.model.addComponent(
      ComponentData(
        position: componentPosition,
        data: MyComponentData.copy(componentData.data),
        size: componentData.size,
        minSize: componentData.minSize,
        type: componentData.type,
      ),
    );

    canvasWriter.model.moveComponentToTheFrontWithChildren(componentId);
  }
}
