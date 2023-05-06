import 'package:diagram/design/atoms.dart' as atoms;
import 'package:diagram/design/molecules.dart' as molecules;
import 'package:diagram/simple_diagram_editor/dialog/edit_component_dialog.dart';
import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram/simple_diagram_editor/widget/option_icon.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` MyComponentWidgetsPolicy
mixin MyComponentWidgetsPolicy implements ComponentWidgetsPolicy, CustomStatePolicy {
  // q` > showCustomWidgetWithComponentDataOver
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

  // q` _tools
  Widget _tools(ComponentData componentData, context) {
    final borderSize = componentData.data.borderWidth * canvasReader.state.scale;
    Offset componentPosition = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - borderSize / 2,
      top: componentPosition.dy - borderSize / 2 - 48 - atoms.Sizes.md,
      child: DecoratedBox(
        decoration: atoms.BoxDecorations.md,
        child: Padding(
          padding: atoms.EdgeInsets.md,
          child: Row(
            children: [
              // Edit
              molecules.IconTap(
                tip: 'Edit',
                icon: atoms.Icons.edit,
                onTap: () => showEditComponentDialog(context, componentData),
              ),
              const molecules.Divider(),
              // Dulplcate
              molecules.IconTap(
                tip: 'Duplicate',
                icon: atoms.Icons.copy,
                onTap: () {
                  String newId = duplicate(componentData);
                  canvasWriter.model.moveComponentToTheFront(newId);
                  selectedComponentId = newId;
                  hideComponentHighlight(componentData.id);
                  highlightComponent(newId);
                },
              ),
              // Bring to Front
              const molecules.Gap(),
              molecules.IconTap(
                tip: 'Bring to Front',
                icon: atoms.Icons.bringToFront,
                onTap: () => canvasWriter.model.moveComponentToTheFront(componentData.id),
              ),
              // Send to Back
              const molecules.Gap(),
              molecules.IconTap(
                tip: 'Send to Back',
                icon: atoms.Icons.sendToBack,
                onTap: () => canvasWriter.model.moveComponentToTheBack(componentData.id),
              ),
              const molecules.Divider(),
              // Add Link
              molecules.IconTap(
                tip: 'Add Connection',
                icon: atoms.Icons.addConnection,
                onTap: () {
                  isReadyToConnect = true;
                  componentData.updateComponent();
                },
              ),
              // Remove Links
              const molecules.Gap(),
              molecules.IconTap(
                tip: 'Remove Connection',
                icon: atoms.Icons.removeConnection,
                onTap: () => canvasWriter.model.removeComponentConnections(componentData.id),
              ),
              // Divider
              const molecules.Gap(),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const SizedBox(
                  width: 1,
                  height: 24,
                ),
              ),
              // Delete
              const molecules.Gap(),
              molecules.IconTap(
                tip: 'Remove',
                icon: atoms.Icons.remove,
                color: atoms.Colors.bad,
                onTap: () {
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

  // q _hilite
  Widget _hilite(ComponentData componentData, Color color) {
    final borderSize = componentData.data.borderWidth * canvasReader.state.scale;
    Offset topLeft = canvasReader.state.toCanvasCoordinates(componentData.position);
    Offset bottomRight =
        canvasReader.state.toCanvasCoordinates(componentData.position + componentData.size.bottomRight(Offset.zero));
    final size = Size(bottomRight.dx - topLeft.dx, bottomRight.dy - topLeft.dy);
    return Positioned(
      top: topLeft.dy - borderSize / 2,
      left: topLeft.dx - borderSize / 2,
      child: IgnorePointer(
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
      ),
    );
  }

  // q` _resize
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

  // q` _junction
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
