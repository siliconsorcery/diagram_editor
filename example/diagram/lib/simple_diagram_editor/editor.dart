import 'package:diagram/design/atoms.dart' as atoms;
import 'package:diagram/design/molecules.dart' as molecules;
import 'package:diagram/simple_diagram_editor/policy/minimap_policy.dart';
import 'package:diagram/simple_diagram_editor/policy/my_policy_set.dart';
import 'package:diagram/simple_diagram_editor/widget/menu.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` SimpleDemoEditor
class SimpleDemoEditor extends StatefulWidget {
  const SimpleDemoEditor({super.key});

  @override
  _SimpleDemoEditorState createState() => _SimpleDemoEditorState();
}

class _SimpleDemoEditorState extends State<SimpleDemoEditor> {
  DiagramEditorContext? diagramEditorContext;
  DiagramEditorContext? diagramEditorContextMiniMap;

  final myPolicySet = MyPolicySet();
  final miniMapPolicySet = MiniMapPolicySet();

  bool isMiniMapVisible = true;
  bool isMenuVisible = true;
  bool isOptionsVisible = true;

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(
      diagramEditorContext!,
      policySet: miniMapPolicySet,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              DiagramEditor(
                diagramEditorContext: diagramEditorContext!,
              ),

              // q` ⭐️ Overlay UI

              // q` Minimap
              Positioned(
                right: atoms.Insets.xxl,
                top: atoms.Insets.xxl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: atoms.BoxDecorations.md,
                      child: Padding(
                        padding: atoms.EdgeInsets.md,
                        child: Row(
                          children: [
                            // Toogle Map
                            molecules.IconTap(
                              tip: 'View Minimap',
                              icon: atoms.Icons.miniMap,
                              isSelected: isMiniMapVisible,
                              onTap: () {
                                setState(() {
                                  isMiniMapVisible = !isMiniMapVisible;
                                });
                              },
                            ),
                            // Reset View
                            const molecules.Gap(),
                            molecules.IconTap(
                              tip: 'Reset View',
                              icon: atoms.Icons.resetView,
                              onTap: () => myPolicySet.resetView(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Minmap
                    const molecules.Gap(),
                    Visibility(
                      visible: isMiniMapVisible,
                      child: Container(
                        decoration: atoms.BoxDecorations.md,
                        child: SizedBox(
                          width: 320,
                          height: 180,
                          child: DiagramEditor(
                            diagramEditorContext: diagramEditorContextMiniMap!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // q` Tools
              Positioned(
                bottom: atoms.Insets.xxl,
                left: atoms.Insets.xxl,
                child: DecoratedBox(
                  decoration: atoms.BoxDecorations.md,
                  child: Padding(
                    padding: atoms.EdgeInsets.md,
                    child: Row(
                      children: [
                        // Selection Mode
                        molecules.IconTap(
                          tip: 'Shapes',
                          icon: atoms.Icons.shapes,
                          isSelected: isMenuVisible,
                          onTap: () {
                            setState(
                              () {
                                isMenuVisible = !isMenuVisible;
                              },
                            );
                          },
                        ),
                        // Selection Mode
                        const SizedBox(width: atoms.Insets.lg),
                        molecules.IconTap(
                          tip: 'Multiselection',
                          icon: atoms.Icons.selection,
                          isSelected: myPolicySet.isMultipleSelectionOn,
                          onTap: () {
                            setState(
                              () {
                                if (myPolicySet.isMultipleSelectionOn) {
                                  myPolicySet.turnOffMultipleSelection();
                                } else {
                                  myPolicySet.turnOnMultipleSelection();
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // q` Multiple Selection Tools
              Positioned(
                bottom: atoms.Insets.xxl + 48 + atoms.Insets.md,
                left: atoms.Insets.xxl,
                child: Visibility(
                  visible: myPolicySet.isMultipleSelectionOn,
                  child: DecoratedBox(
                    decoration: atoms.BoxDecorations.md,
                    child: Padding(
                      padding: atoms.EdgeInsets.md,
                      child: Row(
                        children: [
                          molecules.IconTap(
                            tip: 'Select All',
                            icon: atoms.Icons.selectAll,
                            onTap: () => myPolicySet.selectAll(),
                          ),
                          const molecules.Gap(),
                          molecules.IconTap(
                              tip: 'Duplicate Selected',
                              icon: atoms.Icons.duplicateSelected,
                              onTap: () => myPolicySet.duplicateSelected()),
                          const molecules.Gap(),
                          molecules.IconTap(
                              tip: 'Remove Selected',
                              icon: atoms.Icons.removeSelected,
                              color: atoms.Colors.bad,
                              onTap: () => myPolicySet.removeSelected()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // q` Menu Parts
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Visibility(
                      visible: isMenuVisible,
                      child: Container(
                        decoration: atoms.BoxDecorations.md,
                        // color: ColorAtoms.paper,
                        width: 120,
                        height: 420,
                        child: DraggableMenu(myPolicySet: myPolicySet),
                      ),
                    ),
                  ],
                ),
              ),

              // q` Back Button
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
