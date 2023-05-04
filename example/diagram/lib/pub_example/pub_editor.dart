import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

void main() => runApp(const PubDiagramEditor());

class PubDiagramEditor extends StatefulWidget {
  const PubDiagramEditor({super.key});

  @override
  _PubDiagramEditorState createState() => _PubDiagramEditorState();
}

class _PubDiagramEditorState extends State<PubDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              DiagramEditor(
                diagramEditorContext: DiagramEditorContext(
                  policySet: myPolicySet,
                ),
              ),
              Positioned(
                bottom: 32,
                left: 32,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 243, 33, 33),
                    )),
                    child: const Text('Delete All'),
                    onPressed: () => myPolicySet.deleteAllComponents()),
              ),
              Positioned(
                top: 32,
                left: 32,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('Back'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom component Data which you can assign to a component to data property.
class MyComponentData {
  bool isHighlightVisible = false;
  Color color = Color.fromARGB(
    255,
    (math.Random().nextDouble() * 63 + 182).toInt(),
    (math.Random().nextDouble() * 63 + 182).toInt(),
    (math.Random().nextDouble() * 63 + 182).toInt(),
  );

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}

// A set of policies compound of mixins. There are some custom policy implementations and some policies defined by diagram_editor library.
class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyComponentDesignPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        CustomPolicy,
        //
        CanvasControlPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy,
        LinkAttachmentRectPolicy {}

// A place where you can init the canvas or your diagram (eg. load an existing diagram).
mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setCanvasColor(Colors.white);
  }
}

// This is the place where you can design a component.
// Use switch on componentData.type or componentData.data to define different component designs.
mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    final isHilit = (componentData.data as MyComponentData).isHighlightVisible;
    return Container(
      decoration: BoxDecoration(
        color: (componentData.data as MyComponentData).color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: isHilit ? 4 : 2,
          color: isHilit ? const Color.fromARGB(255, 30, 128, 233) : const Color.fromARGB(255, 92, 92, 92),
        ),
      ),
      child: const Center(child: Text('Node')),
    );
  }
}

// You can override the behavior of any gesture on canvas here.
// Note that it also implements CustomPolicy where own variables and functions can be defined and used here.
mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    canvasWriter.model.hideAllLinkJoints();
    if (selectedComponentId.isNotEmpty) {
      hideComponentHighlight(selectedComponentId);
    } else {
      canvasWriter.model.addComponent(
        ComponentData(
          size: const Size(96, 72),
          position: canvasReader.state.fromCanvasCoordinates(details.localPosition) - const Offset(96 / 2, 72 / 2),
          data: MyComponentData(),
        ),
      );
    }
  }
}

// Mixin where component behaviour is defined. In this example it is the movement, highlight and connecting two components.
mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  // variable used to calculate delta offset to move the component.
  Offset lastFocalPoint = Offset.zero;

  @override
  onComponentTap(String componentId) {
    canvasWriter.model.hideAllLinkJoints();

    bool connected = connectComponents(selectedComponentId, componentId);
    if (selectedComponentId.isNotEmpty) {
      hideComponentHighlight(selectedComponentId);
    }
    if (!connected) {
      highlightComponent(componentId);
    }
  }

  @override
  onComponentLongPress(String componentId) {
    hideComponentHighlight(selectedComponentId);
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

  // This function tests if it's possible to connect the components and if yes, connects them
  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (targetComponentId.isEmpty) {
      return false;
    }
    // tests if the ids are not same (the same component)
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    // tests if the connection between two components already exists (one way)
    if (sourceComponentId.isNotEmpty &&
        canvasReader.model
            .getComponent(sourceComponentId)
            .connections
            .any((connection) => (connection is ConnectionOut) && (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    // This connects two components (creates a link between), you can define the design of the link with LinkStyle.
    if (sourceComponentId.isNotEmpty && targetComponentId.isNotEmpty) {
      canvasWriter.model.connectTwoComponents(
        sourceComponentId: sourceComponentId,
        targetComponentId: targetComponentId,
        linkStyle: LinkStyle(
          arrowType: ArrowType.pointedArrow,
          lineWidth: 1.5,
          backArrowType: ArrowType.centerCircle,
        ),
      );
      return true;
    } else {
      return false;
    }
  }
}

// You can create your own Policy to define own variables and functions with canvasReader and canvasWriter.
mixin CustomPolicy implements PolicySet {
  String selectedComponentId = '';

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).data.showHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
    selectedComponentId = componentId;
  }

  hideComponentHighlight(String componentId) {
    canvasReader.model.getComponent(componentId).data.hideHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
    selectedComponentId = '';
  }

  deleteAllComponents() {
    selectedComponentId = '';
    canvasWriter.model.removeAllComponents();
  }
}
