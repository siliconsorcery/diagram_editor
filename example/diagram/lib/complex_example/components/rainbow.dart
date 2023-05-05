import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class RainbowItem extends StatelessWidget {
  final Color color;
  final double width;

  const RainbowItem({
    Key? key,
    required this.color,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: color.toString(),
      child: Container(width: width, color: color),
    );
  }
}

class ComplexRainbowComponent extends StatelessWidget {
  final ComponentData componentData;

  const ComplexRainbowComponent({
    Key? key,
    required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // componentData.data.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 4,
          color: componentData.data.isHighlightVisible
              ? const Color.fromARGB(255, 43, 114, 237)
              : const Color.fromARGB(0, 0, 0, 0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello Again',
              style: TextStyle(
                fontSize: 28,
                letterSpacing: -0.2,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 8,
            ),
            const Text(
              'This is a bit more complex component.\nTry to scroll the rainbow below.',
              style: TextStyle(fontSize: 12, letterSpacing: -0.1, height: 1.5),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const <Widget>[
                  RainbowItem(width: 80, color: Colors.red),
                  RainbowItem(width: 80, color: Colors.orange),
                  RainbowItem(width: 80, color: Colors.amber),
                  RainbowItem(width: 80, color: Colors.yellow),
                  RainbowItem(width: 80, color: Colors.lime),
                  RainbowItem(width: 80, color: Colors.green),
                  RainbowItem(width: 80, color: Colors.cyan),
                  RainbowItem(width: 80, color: Colors.blue),
                  RainbowItem(width: 80, color: Colors.indigo),
                  RainbowItem(width: 80, color: Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.emoji_emotions, color: Color.fromARGB(255, 253, 224, 80), size: 64),
                Icon(Icons.ac_unit_outlined, color: Color.fromARGB(255, 134, 171, 245), size: 64),
                Icon(Icons.gesture, color: Color.fromARGB(255, 24, 148, 24), size: 64),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
