import 'package:diagram/design/atoms.dart' as atoms;
import 'package:diagram/simple_diagram_editor/data/custom_component_data.dart';
import 'package:diagram/simple_diagram_editor/policy/my_policy_set.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class DraggableMenu extends StatelessWidget {
  final MyPolicySet myPolicySet;

  const DraggableMenu({
    Key? key,
    required this.myPolicySet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...myPolicySet.bodies.map(
          (componentType) {
            var componentData = getComponentData(componentType);
            return Padding(
              padding: atoms.EdgeInsets.lg,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth < componentData.size.width
                        ? componentData.size.width * (constraints.maxWidth / componentData.size.width)
                        : componentData.size.width,
                    height: constraints.maxWidth < componentData.size.width
                        ? componentData.size.height * (constraints.maxWidth / componentData.size.width)
                        : componentData.size.height,
                    child: Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: componentData.size.aspectRatio,
                        child: Tooltip(
                          message: componentData.type,
                          child: DraggableComponent(
                            myPolicySet: myPolicySet,
                            componentData: componentData,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  ComponentData getComponentData(String componentType) {
    switch (componentType) {
      case 'junction':
        return ComponentData(
          size: const Size(16, 16),
          minSize: const Size(4, 4),
          data: MyComponentData(
            color: Colors.black,
            borderWidth: 0.0,
          ),
          type: componentType,
        );
      default:
        return ComponentData(
          size: const Size(120, 72),
          minSize: const Size(80, 64),
          data: MyComponentData(
            color: Colors.white,
            borderColor: Colors.black,
            borderWidth: 2.0,
          ),
          type: componentType,
        );
    }
  }
}

class DraggableComponent extends StatelessWidget {
  final MyPolicySet myPolicySet;
  final ComponentData componentData;

  const DraggableComponent({
    Key? key,
    required this.myPolicySet,
    required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentData>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: myPolicySet.showComponentBody(componentData),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: componentData.size.width,
          height: componentData.size.height,
          child: myPolicySet.showComponentBody(componentData),
        ),
      ),
      child: myPolicySet.showComponentBody(componentData),
    );
  }
}
