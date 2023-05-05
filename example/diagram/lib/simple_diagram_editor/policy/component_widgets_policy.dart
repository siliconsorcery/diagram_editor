import 'package:diagram/simple_diagram_editor/dialog/edit_component_dialog.dart';
import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram/simple_diagram_editor/widget/option_icon.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(BuildContext context, ComponentData componentData) {
    bool isJunction = componentData.type == 'junction';
    bool showOptions = (!isMultipleSelectionOn) && (!isReadyToConnect) && !isJunction;

    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          if (showOptions) _tools(componentData, context),
          // if (showOptions) _bottomTools(componentData),
          _hilite(componentData,
              isMultipleSelectionOn ? const Color.fromARGB(255, 14, 183, 19) : const Color.fromARGB(255, 55, 150, 213)),
          if (showOptions) _resize(componentData),
          if (isJunction && !isReadyToConnect) _junction(componentData),
        ],
      ),
    );
  }

  Widget _tools(ComponentData componentData, context) {
    final borderSize = componentData.data.borderWidth * canvasReader.state.scale;
    Offset componentPosition = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - borderSize / 2,
      top: componentPosition.dy - borderSize / 2 - 48,
      child: DecoratedBox(
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
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            children: [
              // Edit
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 43, 124, 216),
                  size: 24,
                ),
                onPressed: () => showEditComponentDialog(context, componentData),
              ),
              // Divider
              const SizedBox(width: 6),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const SizedBox(
                  width: 2,
                  height: 24,
                ),
              ),
              // Dulplcate
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Duplicate',
                icon: const Icon(
                  Icons.copy,
                  color: Color.fromARGB(255, 43, 124, 216),
                  size: 24,
                ),
                onPressed: () {
                  String newId = duplicate(componentData);
                  canvasWriter.model.moveComponentToTheFront(newId);
                  selectedComponentId = newId;
                  hideComponentHighlight(componentData.id);
                  highlightComponent(newId);
                },
              ),
              // Top
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Top',
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Color.fromARGB(255, 43, 124, 216),
                  size: 24,
                ),
                onPressed: () => canvasWriter.model.moveComponentToTheFront(componentData.id),
              ),
              // Bottom
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Bottom',
                icon: const Icon(
                  Icons.arrow_downward,
                  color: Color.fromARGB(255, 43, 124, 216),
                  size: 24,
                ),
                onPressed: () => canvasWriter.model.moveComponentToTheBack(componentData.id),
              ),
              // Divider
              const SizedBox(width: 4),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const SizedBox(
                  width: 2,
                  height: 24,
                ),
              ),
              const SizedBox(width: 4),
              // Add Link
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Add Links',
                icon: const Icon(
                  Icons.arrow_right_alt,
                  color: Color.fromARGB(255, 43, 124, 216),
                  size: 24,
                ),
                onPressed: () {
                  isReadyToConnect = true;
                  componentData.updateComponent();
                },
              ),
              // Remove Links
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Remove Links',
                icon: const Icon(
                  Icons.link_off,
                  color: Color.fromARGB(255, 43, 124, 216),
                  size: 24,
                ),
                onPressed: () => canvasWriter.model.removeComponentConnections(componentData.id),
              ),
              // Divider
              const SizedBox(width: 6),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const SizedBox(
                  width: 2,
                  height: 24,
                ),
              ),
              // Delete
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(
                  Icons.delete_forever,
                  color: Color.fromARGB(255, 216, 43, 43),
                  size: 24,
                ),
                onPressed: () {
                  canvasWriter.model.removeComponent(componentData.id);
                  selectedComponentId = null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hilite(ComponentData componentData, Color color) {
    final borderSize = componentData.data.borderWidth * canvasReader.state.scale;
    Offset topLeft = canvasReader.state.toCanvasCoordinates(componentData.position);
    Offset bottomRight =
        canvasReader.state.toCanvasCoordinates(componentData.position + componentData.size.bottomRight(Offset.zero));
    final size = Size(bottomRight.dx - topLeft.dx, bottomRight.dy - topLeft.dy);
    return Positioned(
      top: topLeft.dy - borderSize / 2,
      left: topLeft.dx - borderSize / 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withAlpha(32),
          border: Border.fromBorderSide(BorderSide(color: color, width: 3)),
        ),
        child: SizedBox(
          width: size.width + borderSize,
          height: size.height + borderSize,
        ),
      ),
    );
  }

  Widget _resize(ComponentData componentData) {
    final borderSize = componentData.data.borderWidth * canvasReader.state.scale;

    Offset componentBottomRightCorner = canvasReader.state.toCanvasCoordinates(
      componentData.position + componentData.size.bottomRight(Offset.zero),
    );
    return Positioned(
      left: componentBottomRightCorner.dx + borderSize / 2 - 16 - 2,
      top: componentBottomRightCorner.dy + borderSize / 2 - 16 - 2,
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

  Widget _junction(ComponentData componentData) {
    Offset componentPosition = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 32,
            onPressed: () {
              canvasWriter.model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 8),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 32,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }
}
