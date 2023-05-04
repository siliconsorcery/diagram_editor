import 'package:diagram/grid_example/widget/basic_component.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    return BasicComponent();
  }
}
