import 'package:diagram/hierarchical_example/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy, CustomPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    final text = Text(
      'id: ${componentData.id.substring(0, 4)}',
      style: const TextStyle(fontSize: 10),
    );
    return Container(
      decoration: BoxDecoration(
          color: componentData.data.color,
          border: Border.all(
              width: 2,
              color: componentData.data.isHighlightVisible
                  ? const Color.fromARGB(255, 30, 111, 233)
                  : const Color.fromARGB(0, 99, 99, 99)),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(64, 0, 0, 0),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ]),
      child: Center(
        child: isReadyToAddParent
            ? const Text('tap on parent', style: TextStyle(fontSize: 10))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text,
                  Text(
                    componentData.parentId == null ? 'no parent' : 'parent: ${componentData.parentId!.substring(0, 4)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
      ),
    );
  }
}
