import 'package:diagram/design/atoms.dart' as atoms;
import 'package:diagram/design/molecules.dart' as molecules;
import 'package:diagram/simple_diagram_editor/dialog/edit_link_dialog.dart';
import 'package:diagram/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

// q` MyLinkWidgetsPolicy
mixin MyLinkWidgetsPolicy implements LinkWidgetsPolicy, CustomStatePolicy {
  // q` > showWidgetsWithLinkData
  @override
  List<Widget> showWidgetsWithLinkData(BuildContext context, LinkData linkData) {
    double linkLabelSize = 32;
    var linkStartLabelPosition = _labelPosition(
      linkData.linkPoints.first,
      linkData.linkPoints[1],
      linkLabelSize / 2,
      false,
    );
    var linkEndLabelPosition = _labelPosition(
      linkData.linkPoints.last,
      linkData.linkPoints[linkData.linkPoints.length - 2],
      linkLabelSize / 2,
      true,
    );

    return [
      _label(
        linkStartLabelPosition,
        linkData.data.startLabel,
        linkLabelSize,
      ),
      _label(
        linkEndLabelPosition,
        linkData.data.endLabel,
        linkLabelSize,
      ),
      if (selectedLinkId == linkData.id) _showLinkOptions(context, linkData),
    ];
  }

  // q` _showLinkOptions
  Widget _showLinkOptions(BuildContext context, LinkData linkData) {
    var nPos = canvasReader.state.toCanvasCoordinates(tapLinkPosition);
    return Positioned(
      left: nPos.dx - 40,
      top: nPos.dy - 40,
      child: Container(
        decoration: atoms.BoxDecorations.md,
        child: Padding(
          padding: atoms.EdgeInsets.md,
          child: Row(
            children: [
              molecules.IconTap(
                tip: 'Remove Connection',
                icon: atoms.Icons.edit,
                onTap: () {
                  showEditLinkDialog(
                    context,
                    linkData,
                  );
                },
              ),
              const molecules.Divider(),
              molecules.IconTap(
                tip: 'Remove Connection',
                icon: atoms.Icons.remove,
                color: atoms.Colors.bad,
                onTap: () => canvasWriter.model.removeLink(linkData.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // q` _label
  Widget _label(Offset position, String label, double size) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size * canvasReader.state.scale,
      height: size * canvasReader.state.scale,
      child: GestureDetector(
        onTap: () {},
        onLongPress: () {},
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10 * canvasReader.state.scale,
            ),
          ),
        ),
      ),
    );
  }

  // q` _labelPosition
  Offset _labelPosition(
    Offset point1,
    Offset point2,
    double labelSize,
    bool left,
  ) {
    var normalized = VectorUtils.normalizeVector(point2 - point1);

    return canvasReader.state.toCanvasCoordinates(point1 -
        Offset(labelSize, labelSize) +
        normalized * labelSize +
        VectorUtils.getPerpendicularVectorToVector(normalized, left) * labelSize);
  }
}
