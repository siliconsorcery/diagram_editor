import 'package:diagram/ports_example/policy/policy_set.dart';
import 'package:diagram/ports_example/widget/port_switch.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class PortsDiagramEditor extends StatefulWidget {
  const PortsDiagramEditor({super.key});

  @override
  _PortsDiagramEditorState createState() => _PortsDiagramEditorState();
}

class _PortsDiagramEditorState extends State<PortsDiagramEditor> {
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
                        backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 243, 33, 33),
                    )),
                    child: const Text('Delete All'),
                    onPressed: () => myPolicySet.deleteAllComponents()),
              ),
              PortSwitch(policySet: myPolicySet),
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
