import 'package:diagram/hierarchical_example/policy/custom_policy.dart';
import 'package:diagram/simple_diagram_editor/widget/option_icon.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy implements ComponentWidgetsPolicy, CustomPolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(
    BuildContext context,
    ComponentData componentData,
  ) {
    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          _hilite(componentData),
          _resize(componentData),
          _tools(componentData, context),
          _stack(componentData),
        ],
      ),
    );
  }

  Widget _tools(ComponentData componentData, context) {
    Offset origin = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      top: origin.dy - 44,
      left: origin.dx,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(64, 24, 119, 229), blurRadius: 4, spreadRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Text('Hello Again!'),
                  // const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Add Parent',
                    icon: const Icon(
                      Icons.person_add,
                      color: Color.fromARGB(255, 43, 124, 216),
                      size: 24,
                    ),
                    onPressed: () {
                      isReadyToAddParent = true;
                      componentData.updateComponent();
                    },
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Remove Parent',
                    icon: const Icon(
                      Icons.person_remove,
                      color: Color.fromARGB(255, 43, 124, 216),
                      size: 24,
                    ),
                    onPressed: () {
                      canvasWriter.model.removeComponentParent(componentData.id);
                      componentData.updateComponent();
                    },
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Color.fromARGB(255, 216, 43, 43),
                      size: 24,
                    ),
                    onPressed: () {
                      canvasWriter.model.removeComponent(componentData.id);
                      selectedComponentId = '';
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stack(ComponentData componentData) {
    Offset componentBottomLeftCorner = canvasReader.state.toCanvasCoordinates(
      componentData.position + componentData.size.bottomLeft(Offset.zero),
    );
    return Positioned(
      left: componentBottomLeftCorner.dx,
      top: componentBottomLeftCorner.dy + 4,
      child: Row(
        children: [
          OptionIcon(
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            iconColor: const Color.fromARGB(255, 43, 124, 216),
            size: 28,
            onPressed: () => canvasWriter.model.moveComponentToTheFront(componentData.id),
          ),
          const SizedBox(width: 8),
          OptionIcon(
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            iconColor: const Color.fromARGB(255, 43, 124, 216),
            size: 28,
            onPressed: () => canvasWriter.model.moveComponentToTheBack(componentData.id),
          ),
        ],
      ),
    );
  }

  Widget _hilite(ComponentData componentData) {
    Offset origin = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      top: origin.dy,
      left: origin.dx,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(32, 54, 133, 244),
        ),
        child: SizedBox(
          width: componentData.size.width,
          height: componentData.size.height,
        ),
      ),
    );
  }

  Widget _resize(ComponentData componentData) {
    Offset componentBottomRightCorner = canvasReader.state.toCanvasCoordinates(
      componentData.position + componentData.size.bottomRight(Offset.zero),
    );
    return Positioned(
      left: componentBottomRightCorner.dx - 16 - 2,
      top: componentBottomRightCorner.dy - 16 - 2,
      child: GestureDetector(
        onPanUpdate: (details) {
          canvasWriter.model.resizeComponent(
            componentData.id,
            details.delta / canvasReader.state.scale,
          );
          canvasWriter.model.updateComponentLinks(componentData.id);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 32,
            height: 32,
            color: Colors.black.withOpacity(0.0),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 41, 118, 219),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
