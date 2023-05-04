import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class PortComponent extends StatelessWidget {
  final ComponentData componentData;

  const PortComponent({
    Key? key,
    required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PortData portData = componentData.data;

    switch (portData.portState) {
      case PortState.hidden:
        return const SizedBox.shrink();
      case PortState.shown:
        return Port(
          color: portData.color,
          borderColor: const Color.fromARGB(255, 203, 203, 203),
        );
      case PortState.selected:
        return Port(
          color: portData.color,
          borderColor: const Color.fromARGB(255, 255, 255, 255),
        );
      case PortState.highlighted:
        return Port(
          color: portData.color,
          borderColor: const Color.fromARGB(255, 255, 248, 50),
        );
    }
  }
}

class Port extends StatelessWidget {
  final Color color;
  final Color borderColor;

  const Port({
    Key? key,
    this.color = Colors.white,
    this.borderColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: borderColor,
        ),
      ),
    );
  }
}

enum PortState { hidden, shown, selected, highlighted }

class PortData {
  final String type;
  final Color color;
  final Size size;
  final Alignment alignmentOnComponent;

  PortState portState = PortState.shown;

  PortData({
    required this.type,
    required this.color,
    required this.size,
    required this.alignmentOnComponent,
  });

  setPortState(PortState portState) {
    this.portState = portState;
  }
}
