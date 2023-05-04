import 'dart:math' as math;

import 'package:diagram/ports_example/widget/port_component.dart';
import 'package:diagram/ports_example/widget/rect_component.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin CustomPolicy implements PolicySet {
  List<String> componentTypes = [
    'center',
    'zero-one',
    'one_zero',
    'one-one',
    'one-two',
    'two-one',
    'two-two',
    'corners',
  ];

  deleteAllComponents() {
    canvasWriter.model.removeAllComponents();
  }

  String selectedPortId = '';
  bool arePortsVisible = true;

  bool canConnectThesePorts(String portId1, String portId2) {
    if (portId1.isEmpty || portId2.isEmpty) {
      return false;
    }
    if (portId1 == portId2) {
      return false;
    }
    var port1 = canvasReader.model.getComponent(portId1);
    var port2 = canvasReader.model.getComponent(portId2);
    if (port1.type != 'port' || port2.type != 'port') {
      return false;
    }

    if (port1.data.type != port2.data.type) {
      return false;
    }

    if (port1.connections.any((connection) => (connection.otherComponentId == portId2))) {
      return false;
    }

    if (port1.parentId == port2.parentId) {
      return false;
    }

    return true;
  }

  selectPort(String portId) {
    var port = canvasReader.model.getComponent(portId);
    port.data.setPortState(PortState.selected);
    port.updateComponent();
    selectedPortId = portId;

    canvasReader.model.getAllComponents().values.forEach((port) {
      if (canConnectThesePorts(portId, port.id)) {
        (port.data as PortData).setPortState(PortState.highlighted);
        port.updateComponent();
      }
    });
  }

  deselectAllPorts() {
    selectedPortId = '';

    canvasReader.model.getAllComponents().values.forEach((component) {
      if (component.type == 'port') {
        (component.data as PortData).setPortState(arePortsVisible ? PortState.shown : PortState.hidden);
        component.updateComponent();
      }
    });
  }

  switchPortsVisibility() {
    selectedPortId = '';
    if (arePortsVisible) {
      arePortsVisible = false;
      canvasReader.model.getAllComponents().values.forEach((component) {
        if (component.type == 'port') {
          (component.data as PortData).setPortState(PortState.hidden);
          component.updateComponent();
        }
      });
    } else {
      arePortsVisible = true;
      canvasReader.model.getAllComponents().values.forEach((component) {
        if (component.type == 'port') {
          (component.data as PortData).setPortState(PortState.shown);
          component.updateComponent();
        }
      });
    }
  }

  addComponentDataWithPorts(Offset position) {
    String type = componentTypes[math.Random().nextInt(componentTypes.length)];

    var componentData = _getComponentData(type, position);
    canvasWriter.model.addComponent(componentData);
    int zOrder = canvasWriter.model.moveComponentToTheFront(componentData.id);
    componentData.data.portData.forEach((PortData port) {
      var newPort = ComponentData(
        size: port.size,
        type: 'port',
        data: port,
        position: componentData.position +
            componentData.getPointOnComponent(port.alignmentOnComponent) -
            port.size.center(Offset.zero),
      );
      canvasWriter.model.addComponent(newPort);
      canvasWriter.model.setComponentParent(newPort.id, componentData.id);
      newPort.zOrder = zOrder + 1;
    });
  }

  ComponentData _getComponentData(String type, Offset position) {
    var portComponent = ComponentData(
      size: const Size(120, 120),
      position: position - const Offset(60, 60),
      type: 'component',
      data: MyComponentData(
        color: Color.fromARGB(
          255,
          (math.Random().nextDouble() * 63 + 182).toInt(),
          (math.Random().nextDouble() * 63 + 182).toInt(),
          (math.Random().nextDouble() * 63 + 182).toInt(),
        ),
      ),
    );

    switch (type) {
      case 'center':
        portComponent.data.portData.add(_getPortData(Alignment.center));
        break;
      case 'zero-one':
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        break;
      case 'one_zero':
        portComponent.data.portData.add(_getPortData(Alignment.centerLeft));
        break;
      case 'one-one':
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        portComponent.data.portData.add(_getPortData(Alignment.centerLeft));
        break;
      case 'one-two':
        portComponent.data.portData.add(_getPortData(Alignment.centerLeft));
        portComponent.data.portData.add(_getPortData(const Alignment(1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(1, 0.5)));
        break;
      case 'two-one':
        portComponent.data.portData.add(_getPortData(const Alignment(-1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(-1, 0.5)));
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        break;
      case 'two-two':
        portComponent.data.portData.add(_getPortData(const Alignment(-1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(-1, 0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(1, 0.5)));
        break;
      case 'corners':
        portComponent.data.portData.add(_getPortData(Alignment.topLeft));
        portComponent.data.portData.add(_getPortData(Alignment.topRight));
        portComponent.data.portData.add(_getPortData(Alignment.bottomRight));
        portComponent.data.portData.add(_getPortData(Alignment.bottomLeft));
        break;
      default:
        break;
    }
    return portComponent;
  }

  PortData _getPortData(Alignment alignment) {
    var portType = ['R', 'G', 'B'][math.Random().nextInt(3)];
    Color portColor;
    switch (portType) {
      case 'R':
        portColor = Colors.red;
      case 'G':
        portColor = Colors.green;
      case 'B':
        portColor = Colors.blue;
      default:
        portColor = Colors.grey;
    }
    var portData = PortData(
      type: portType,
      color: portColor,
      size: const Size(20, 20),
      alignmentOnComponent: alignment,
    );
    portData.setPortState(arePortsVisible ? PortState.shown : PortState.hidden);
    return portData;
  }
}
