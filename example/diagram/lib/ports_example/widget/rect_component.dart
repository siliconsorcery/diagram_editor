import 'package:diagram/ports_example/widget/port_component.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class RectComponent extends StatelessWidget {
  final ComponentData componentData;

  const RectComponent({
    Key? key,
    required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myCustomData = componentData.data;

    return Container(
      decoration: BoxDecoration(
        color: myCustomData.color,
        border: Border.all(
          width: 2.0,
          color: const Color.fromARGB(255, 163, 163, 163),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class MyComponentData {
  final Color color;
  List<PortData> portData = [];

  MyComponentData({
    this.color = Colors.white,
  });
}
