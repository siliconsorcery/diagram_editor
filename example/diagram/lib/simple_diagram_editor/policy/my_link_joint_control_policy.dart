import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` MyLinkJointControlPolicy
mixin MyLinkJointControlPolicy implements LinkJointPolicy, CustomStatePolicy {
  // q` > onLinkJointLongPress
  @override
  onLinkJointLongPress(int jointIndex, String linkId) {
    canvasWriter.model.removeLinkMiddlePoint(linkId, jointIndex);
    canvasWriter.model.updateLink(linkId);

    hideLinkOption();
  }

  // q` > onLinkJointScaleUpdate
  @override
  onLinkJointScaleUpdate(int jointIndex, String linkId, ScaleUpdateDetails details) {
    canvasWriter.model.setLinkMiddlePointPosition(linkId, details.localFocalPoint, jointIndex);
    canvasWriter.model.updateLink(linkId);

    hideLinkOption();
  }
}
