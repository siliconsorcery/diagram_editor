library atoms;

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

// q` atoms.Colors
abstract final class Colors {
  static const Color transparent = Color(0x00000000);

  static const Color key = Color(0xFF1998D2);
  static const Color key50 = Color(0x7F1998D2);
  static const Color key25 = Color(0x3F1998D2);
  static const Color key10 = Color(0x1F1998D2);

  static const Color alt = Color(0xFFE3AE0F);
  static const Color alt50 = Color(0x7FE3AE0F);
  static const Color alt25 = Color(0x3FE3AE0F);
  static const Color alt10 = Color(0x1FE3AE0F);

  static const Color paper = Color(0xFFFEFFFF);
  static const Color back = Color(0xFFEEF2F4);
  static const Color low = Color(0xFFCDD5D8);
  static const Color mid = Color(0xFF929A9E);
  static const Color high = Color(0xFF484E51);
  static const Color fore = Color(0xFF27292A);
  static const Color ink = Color(0xFF2C2C2F);

  static const Color bad = Color(0xFFDC5050);
  static const Color fine = Color(0xFFE4CF12);
  static const Color good = Color(0xFF4CAF50);
}

// q` atoms.Icons
abstract final class Icons {
  static const selectAll = material.Icons.all_inclusive;
  static const duplicateSelected = material.Icons.copy;
  static const removeSelected = material.Icons.delete_outline;
  static const miniMap = material.Icons.map_outlined;
  static const resetView = material.Icons.restart_alt_outlined;
  static const shapes = material.Icons.format_shapes;
  static const selection = material.Icons.pan_tool_alt_outlined;
  static const edit = material.Icons.edit_outlined;
  static const copy = material.Icons.copy;
  static const bringToFront = material.Icons.arrow_upward;
  static const sendToBack = material.Icons.arrow_downward;
  static const addConnection = material.Icons.arrow_right_alt;
  static const removeConnection = material.Icons.link_off;
  static const remove = material.Icons.delete_outlined;
  static const close = material.Icons.close;
}

// q` atoms.Insets
abstract final class Insets {
  static const xxl = 32.0;
  static const xl = 16.0;
  static const lg = 12.0;
  static const md = 8.0;
  static const sm = 4.0;
  static const xs = 2.0;
  static const xxs = 1.0;
}

// q` atoms.Sizes
abstract final class Sizes {
  static const xxl = 32.0;
  static const xl = 16.0;
  static const lg = 12.0;
  static const md = 8.0;
  static const sm = 4.0;
  static const xs = 2.0;
  static const xxs = 1.0;
}

// q` atoms.EdgeInsets
abstract final class EdgeInsets {
  static const xl = material.EdgeInsets.all(16);
  static const lg = material.EdgeInsets.all(12);
  static const md = material.EdgeInsets.all(8);
  static const sm = material.EdgeInsets.all(4);
  static const xs = material.EdgeInsets.all(2);
}

// q` atoms.BoxDecorations
abstract final class BoxDecorations {
  static const md = BoxDecoration(
    color: Colors.paper,
    boxShadow: [
      BoxShadow(
        color: Colors.key50,
        blurRadius: 4,
      ),
    ],
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  );
}
