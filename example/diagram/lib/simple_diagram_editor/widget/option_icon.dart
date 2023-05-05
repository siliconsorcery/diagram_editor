import 'package:flutter/material.dart';

class OptionIcon extends StatelessWidget {
  final Color color;
  final double size;
  final BoxShape shape;
  final String? tooltip;
  final IconData? iconData;
  final Color iconColor;
  final double iconSize;
  final Function? onPressed;

  const OptionIcon({
    Key? key,
    this.color = Colors.white,
    this.size = 36,
    this.shape = BoxShape.circle,
    this.tooltip,
    this.iconData,
    this.iconColor = const Color.fromARGB(255, 36, 36, 36),
    this.iconSize = 24,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        padding: const EdgeInsets.all(0),
        icon: Icon(
          iconData,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
