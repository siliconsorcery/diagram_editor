import 'package:diagram/grid_example/policy/policy_set.dart';
import 'package:diagram/grid_example/widget/snap_switch.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

void main() => runApp(const GridDiagramEditor());

class GridDiagramEditor extends StatefulWidget {
  const GridDiagramEditor({super.key});

  @override
  _GridDiagramEditorState createState() => _GridDiagramEditorState();
}

class _GridDiagramEditorState extends State<GridDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              DiagramEditor(
                diagramEditorContext: DiagramEditorContext(
                  policySet: myPolicySet,
                ),
              ),
              Positioned(
                bottom: 32,
                left: 32,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Delete All'),
                  onPressed: () => myPolicySet.deleteAllComponents(),
                ),
              ),
              SpanSwitch(policySet: myPolicySet),
              Positioned(
                top: 32,
                left: 32,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('Back'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
