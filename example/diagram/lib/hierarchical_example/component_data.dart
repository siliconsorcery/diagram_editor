import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyComponentData {
  bool isHighlightVisible;
  Color color = Color.fromARGB(
    255,
    (math.Random().nextDouble() * 63 + 182).toInt(),
    (math.Random().nextDouble() * 63 + 182).toInt(),
    (math.Random().nextDouble() * 63 + 182).toInt(),
  );

  MyComponentData({this.isHighlightVisible = false});

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}
