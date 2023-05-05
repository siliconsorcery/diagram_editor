import 'package:diagram/grid_example/policy/policy_set.dart';
import 'package:flutter/material.dart';

class SpanSwitch extends StatefulWidget {
  final MyPolicySet policySet;

  const SpanSwitch({
    Key? key,
    required this.policySet,
  }) : super(key: key);

  @override
  _SpanSwitchState createState() => _SpanSwitchState();
}

class _SpanSwitchState extends State<SpanSwitch> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 142,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber),
        ),
        child: Center(child: Text(widget.policySet.isSnappingEnabled ? 'Snap' : 'Free')),
        onPressed: () {
          widget.policySet.switchIsSnappingEnabled();
          setState(() {});
        },
      ),
    );
  }
}
