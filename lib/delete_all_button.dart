import 'package:flutter/material.dart';
import 'package:flutter_provider_canvas/model/canvas_model.dart';
import 'package:provider/provider.dart';

class DeleteAllButton extends StatelessWidget {
  final double size;
  final Color color;
  final Color iconColor;

  const DeleteAllButton({
    Key key,
    this.size = 48,
    this.color = const Color(0x44000000),
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CanvasModel>(
      builder: (_, canvasData, __) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            color: iconColor,
            onPressed: () {
              canvasData.removeAllComponents();
            },
            tooltip: 'Delete all',
            icon: const Icon(Icons.delete_forever),
          ),
        );
      },
    );
  }
}
