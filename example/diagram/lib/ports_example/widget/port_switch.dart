import 'package:diagram/ports_example/policy/policy_set.dart';
import 'package:flutter/material.dart';

class PortSwitch extends StatefulWidget {
  final MyPolicySet policySet;

  const PortSwitch({
    Key? key,
    required this.policySet,
  }) : super(key: key);

  @override
  _PortSwitchState createState() => _PortSwitchState();
}

class _PortSwitchState extends State<PortSwitch> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 140,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
          Colors.blue,
        )),
        child: Center(child: Text(widget.policySet.arePortsVisible ? 'hide ports' : 'show ports')),
        onPressed: () {
          widget.policySet.switchPortsVisibility();
          setState(() {});
        },
      ),
    );
  }
}
