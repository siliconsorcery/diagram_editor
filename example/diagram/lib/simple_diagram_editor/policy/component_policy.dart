import 'dart:developer';

import 'package:diagram/simple_diagram_editor/data/custom_link_data.dart';
import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` > MyComponentPolicy
mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  // q` > onComponentTap
  @override
  onComponentTap(String componentId) {
    if (isMultipleSelectionOn) {
      if (multipleSelected.contains(componentId)) {
        removeComponentFromMultipleSelection(componentId);
        hideComponentHighlight(componentId);
      } else {
        addComponentToMultipleSelection(componentId);
        highlightComponent(componentId);
      }
    } else {
      hideAllHighlights();

      if (isReadyToConnect) {
        isReadyToConnect = false;
        bool connected = () {
          if (selectedComponentId == null) return false;
          return connectComponents(selectedComponentId!, componentId);
        }();
        if (connected) {
          log('connected');
          selectedComponentId = null;
        } else {
          log('not connected');
          selectedComponentId = componentId;
          highlightComponent(componentId);
        }
      } else {
        selectedComponentId = componentId;
        highlightComponent(componentId);
      }
    }
  }

  Offset lastFocalPoint = Offset.zero;

  // q` > onComponentScaleStart
  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;

    hideLinkOption();
    if (isMultipleSelectionOn) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    }
  }

  // q` > onComponentScaleUpdate
  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    if (isMultipleSelectionOn) {
      for (var compId in multipleSelected) {
        var cmp = canvasReader.model.getComponent(compId);
        canvasWriter.model.moveComponent(compId, positionDelta);
        for (var connection in cmp.connections) {
          if (connection is ConnectionOut && multipleSelected.contains(connection.otherComponentId)) {
            canvasWriter.model.moveAllLinkMiddlePoints(connection.connectionId, positionDelta);
          }
        }
      }
    } else {
      canvasWriter.model.moveComponent(componentId, positionDelta);
    }
    lastFocalPoint = details.localFocalPoint;
  }

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    if (canvasReader.model
        .getComponent(sourceComponentId)
        .connections
        .any((connection) => (connection is ConnectionOut) && (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
      data: MyLinkData(),
    );

    return true;
  }
}
