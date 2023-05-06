import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` MyLinkControlPolicy
mixin MyLinkControlPolicy implements LinkPolicy, CustomStatePolicy {
  // q` > onLinkTapUp
  @override
  onLinkTapUp(String linkId, TapUpDetails details) {
    hideLinkOption();
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.showLinkJoints(linkId);

    showLinkOption(linkId, canvasReader.state.fromCanvasCoordinates(details.localPosition));
  }

  int? segmentIndex;

  // q` > onLinkScaleStart
  @override
  onLinkScaleStart(String linkId, ScaleStartDetails details) {
    hideLinkOption();
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.showLinkJoints(linkId);
    segmentIndex = canvasReader.model.determineLinkSegmentIndex(linkId, details.localFocalPoint);
    if (segmentIndex != null) {
      canvasWriter.model.insertLinkMiddlePoint(linkId, details.localFocalPoint, segmentIndex!);
      canvasWriter.model.updateLink(linkId);
    }
  }

  // q` > onLinkScaleUpdate
  @override
  onLinkScaleUpdate(String linkId, ScaleUpdateDetails details) {
    if (segmentIndex != null) {
      canvasWriter.model.setLinkMiddlePointPosition(linkId, details.localFocalPoint, segmentIndex!);
      canvasWriter.model.updateLink(linkId);
    }
  }

  // q` > onLinkLongPressStart
  @override
  onLinkLongPressStart(String linkId, LongPressStartDetails details) {
    hideLinkOption();
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.showLinkJoints(linkId);
    segmentIndex = canvasReader.model.determineLinkSegmentIndex(linkId, details.localPosition);
    if (segmentIndex != null) {
      canvasWriter.model.insertLinkMiddlePoint(linkId, details.localPosition, segmentIndex!);
      canvasWriter.model.updateLink(linkId);
    }
  }

  // q` > onLinkLongPressMoveUpdate
  @override
  onLinkLongPressMoveUpdate(String linkId, LongPressMoveUpdateDetails details) {
    if (segmentIndex != null) {
      canvasWriter.model.setLinkMiddlePointPosition(linkId, details.localPosition, segmentIndex!);
      canvasWriter.model.updateLink(linkId);
    }
  }
}
