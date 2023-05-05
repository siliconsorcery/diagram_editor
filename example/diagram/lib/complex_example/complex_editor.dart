import 'package:diagram/complex_example/complex_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class ComplexDiagramEditor extends StatefulWidget {
  const ComplexDiagramEditor({super.key});

  @override
  _ComplexDiagramEditorState createState() => _ComplexDiagramEditorState();
}

class _ComplexDiagramEditorState extends State<ComplexDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();
  late DiagramEditorContext diagramEditorContext;

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              DiagramEditor(
                diagramEditorContext: diagramEditorContext,
              ),
              Positioned(
                bottom: 32,
                left: 32,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Row(
                    children: [
                      Text('Delate All'),
                    ],
                  ),
                  onPressed: () => myPolicySet.deleteAllComponents(),
                ),
              ),
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
                      Text('back'),
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
