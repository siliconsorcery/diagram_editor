import 'package:diagram/simple_diagram_editor/policy/minimap_policy.dart';
import 'package:diagram/simple_diagram_editor/policy/my_policy_set.dart';
import 'package:diagram/simple_diagram_editor/widget/menu.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

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

              // q` Overlay UI
              // Minimap
              Positioned(
                right: 32,
                top: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isMiniMapVisible,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Color.fromARGB(255, 3, 112, 255), blurRadius: 4),
                          ],
                        ),
                        child: SizedBox(
                          width: 320,
                          height: 180,
                          child: DiagramEditor(
                            diagramEditorContext: diagramEditorContextMiniMap!,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMiniMapVisible = !isMiniMapVisible;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(color: Color.fromARGB(255, 3, 112, 255), blurRadius: 4),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            isMiniMapVisible ? 'Hide' : 'Show Minimap',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 55, 136, 242),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Tools
              Positioned(
                bottom: 32,
                left: 32,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Color.fromARGB(255, 3, 112, 255), blurRadius: 4),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOptionsVisible = !isOptionsVisible;
                            });
                          },
                          // child: const Text('Go'),
                          child: IconButton(
                            tooltip: 'Toggle',
                            icon: Icon(
                              isOptionsVisible ? Icons.menu_open : Icons.menu,
                              color: const Color.fromARGB(255, 43, 124, 216),
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                isOptionsVisible = !isOptionsVisible;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: isOptionsVisible,
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: 'Reset View',
                                icon: const Icon(
                                  Icons.replay,
                                  color: Color.fromARGB(255, 43, 124, 216),
                                  size: 24,
                                ),
                                onPressed: () => myPolicySet.resetView(),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                tooltip: myPolicySet.isGridVisible ? 'Hide Grid' : 'Show Grid',
                                icon: Icon(
                                  myPolicySet.isGridVisible ? Icons.grid_off : Icons.grid_on,
                                  color: const Color.fromARGB(255, 43, 124, 216),
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    myPolicySet.isGridVisible = !myPolicySet.isGridVisible;
                                  });
                                },
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                tooltip: myPolicySet.isMultipleSelectionOn
                                    ? 'Cancel Multiselection'
                                    : 'Enable Multiselection',
                                icon: Icon(
                                  myPolicySet.isMultipleSelectionOn ? Icons.group_work : Icons.group_work_outlined,
                                  color: const Color.fromARGB(255, 43, 124, 216),
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (myPolicySet.isMultipleSelectionOn) {
                                      myPolicySet.turnOffMultipleSelection();
                                    } else {
                                      myPolicySet.turnOnMultipleSelection();
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                tooltip: 'Delete All',
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Color.fromARGB(255, 216, 43, 43),
                                  size: 24,
                                ),
                                onPressed: () => myPolicySet.removeAll(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Multiple Selection Tools
              Positioned(
                bottom: 32 + 54,
                left: 32 + 84,
                child: Visibility(
                  visible: myPolicySet.isMultipleSelectionOn,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Color.fromARGB(255, 3, 112, 255), blurRadius: 4),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Select All',
                            icon: const Icon(
                              Icons.all_inclusive,
                              color: Color.fromARGB(255, 43, 124, 216),
                              size: 24,
                            ),
                            onPressed: () => myPolicySet.selectAll(),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Duplicate Selected',
                            icon: const Icon(
                              Icons.copy,
                              color: Color.fromARGB(255, 43, 124, 216),
                              size: 24,
                            ),
                            onPressed: () => myPolicySet.duplicateSelected(),
                          ),
                          const SizedBox(height: 4),
                          IconButton(
                            tooltip: 'Remove Selected',
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 216, 43, 43),
                              size: 24,
                            ),
                            onPressed: () => myPolicySet.removeSelected(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Menu Parts
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Visibility(
                      visible: isMenuVisible,
                      child: Container(
                        color: Colors.grey.withOpacity(0.7),
                        width: 120,
                        height: 320,
                        child: DraggableMenu(myPolicySet: myPolicySet),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMenuVisible = !isMenuVisible;
                          });
                        },
                        child: Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(isMenuVisible ? 'hide menu' : 'show menu'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Back Button
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
