import 'package:diagram/grid_example/policy/canvas_policy.dart';
import 'package:diagram/grid_example/policy/canvas_widget_policy.dart';
import 'package:diagram/grid_example/policy/component_design_policy.dart';
import 'package:diagram/grid_example/policy/component_policy.dart';
import 'package:diagram/grid_example/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';

class MyPolicySet extends PolicySet
    with
        MyComponentDesignPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        CustomPolicy,
        MyCanvasWidgetsPolicy,
        //
        CanvasControlPolicy {}
