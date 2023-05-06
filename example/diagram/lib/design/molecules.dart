library molecules;

import 'package:flutter/material.dart';

import 'atoms.dart' as atoms;

// q` molecules.Gap
class Gap extends StatelessWidget {
  const Gap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: atoms.Insets.md,
      height: atoms.Insets.md,
    );
  }
}

// q` molecules.Divider
class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(),
        DecoratedBox(
          decoration: BoxDecoration(
            color: atoms.Colors.low,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const SizedBox(
            width: 1,
            height: 24,
          ),
        ),
        const Gap(),
      ],
    );
  }
}

// q` molecules.IconTap
class IconTap extends StatefulWidget {
  const IconTap({
    super.key,
    this.onTap,
    this.isSelected = false,
    this.hasUI = false,
    this.icon = atoms.Icons.close,
    this.color = atoms.Colors.key,
    this.tip = '',
  });

  final Function()? onTap;
  final bool isSelected;
  final bool hasUI;
  final IconData icon;
  final Color color;
  final String tip;

  @override
  State<IconTap> createState() => _IconTapState();
}

class _IconTapState extends State<IconTap> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isHover
        ? widget.color.withAlpha(128)
        : widget.isSelected
            ? widget.color
            : atoms.Colors.transparent;
    final keyColor = isHover
        ? atoms.Colors.paper
        : widget.isSelected
            ? atoms.Colors.paper
            : widget.color;
    const iconSize = 24.0;
    const size = 32.0;

    final isTip = widget.tip.isNotEmpty;

    return Tooltip(
      message: widget.tip,
      preferBelow: false,
      verticalOffset: 12.0,
      waitDuration: Duration(milliseconds: isTip ? 500 : 1000000),
      child: InkWell(
        onHover: (value) {
          setState(() {
            isHover = value;
          });
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: backgroundColor,
          ),
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                widget.icon,
                color: keyColor,
                size: iconSize,
              ),
              if (widget.hasUI)
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 8,
                    height: 2,
                    color: keyColor.withAlpha(128),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// q` molecules.IconTapSm
class IconTapSm extends StatefulWidget {
  const IconTapSm({
    super.key,
    this.onTap,
    this.isSelected = false,
    this.hasUI = false,
    this.icon = Icons.add_circle_outline,
    this.tip = '',
  });

  final Function()? onTap;
  final bool isSelected;
  final bool hasUI;
  final IconData icon;
  final String tip;

  @override
  State<IconTapSm> createState() => _IconTapSmState();
}

class _IconTapSmState extends State<IconTapSm> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final isTip = widget.tip.isNotEmpty;

    final backgroundColor = isHover
        ? atoms.Colors.key50
        : widget.isSelected
            ? atoms.Colors.key
            : atoms.Colors.transparent;
    final keyColor = isHover
        ? atoms.Colors.paper
        : widget.isSelected
            ? atoms.Colors.paper
            : atoms.Colors.key;
    const iconSize = 18.0;
    const size = 24.0;

    return Tooltip(
      message: widget.tip,
      preferBelow: false,
      verticalOffset: 12.0,
      waitDuration: Duration(milliseconds: isTip ? 500 : 1000000),
      child: InkWell(
        onHover: (value) {
          setState(() {
            isHover = value;
          });
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: backgroundColor,
          ),
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                widget.icon,
                color: keyColor,
                size: iconSize,
              ),
              if (widget.hasUI)
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 8,
                    height: 2,
                    color: keyColor.withAlpha(128),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
