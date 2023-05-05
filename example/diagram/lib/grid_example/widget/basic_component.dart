import 'package:flutter/material.dart';

class BasicComponent extends StatelessWidget {
  const BasicComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(128, 189, 216, 159),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 52, 59, 50),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
