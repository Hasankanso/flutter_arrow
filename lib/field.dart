import 'dart:math';
import 'package:flutter/material.dart';
import 'bottom_bar.dart';
import 'main.dart';
import 'models/arrow_model.dart';
import 'dart:math' as math;

class FieldWidget extends StatefulWidget {
  final int index;
  final GridController gridController;
  final ValueChanged<bool> createArrow;
  final ValueChanged<bool> removeArrow;

  const FieldWidget(
      {super.key,
      required this.gridController,
      required this.index,
      required this.createArrow,
      required this.removeArrow});

  @override
  State<FieldWidget> createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  Color color = Colors.white;
  List<ArrowData> outgoingArrows = [];
  List<ArrowData> incomingArrows = [];
  late final RenderBox box;

  @override
  void initState() {
    color = Color.fromARGB(255, Random().nextInt(80) + 30, 255, 205);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      box = _globalKey.currentContext!.findRenderObject() as RenderBox;
    });
  }

  void onTargetFieldSelected(ArrowData targetField) {
    outgoingArrows.add(targetField);
  }

  @override
  String toStringShort() {
    return "FieldWidget ${widget.index}, outgoingArrows: $outgoingArrows, incomingArrows: $incomingArrows";
  }

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var controller = widget.gridController;
    return InkWell(
      key: _globalKey,
      onTap: () {
        if (controller.bottomBarState == null) return;

        Offset position = box.localToGlobal(Offset.zero);

        print(position);
        ArrowData currentIndexData =
            ArrowData(arrowIndex: widget.index, arrowOffset: position);

        switch (controller.bottomBarState!) {
          case Items.arrow:
            if (controller.creatingArrow) {
              // Edit Essam Get Offset

              controller.arrowEnd = currentIndexData;

              assert(controller.arrowStart != null);
              assert(controller.onArrowCreated != null); // Remove it

              // make sure the arrow is not already created
              if (!incomingArrows.contains(controller.arrowStart)) {
                incomingArrows.add(controller.arrowStart!);

                print(
                    "Arrow created from ${controller.arrowStart?.arrowIndex} to ${controller.arrowEnd?.arrowIndex}");

                Offset p1 = controller.arrowStart!.arrowOffset!;
                Offset p2 = controller.arrowEnd!.arrowOffset!;

                final dX = p2.dx - p1.dx;
                final dY = p2.dy - p1.dy;
                final angle = math.atan2(dY, dX);
                final width = box.size.width;
                final height = box.size.height;

                var pos1X = p1.dx + (width / 2) + math.cos(angle) * (width / 5);

                var pos1Y =
                    p1.dy + (height / 2) + math.sin(angle) * (height / 5);

                var pos2X = p2.dx + (width / 2) - math.cos(angle) * (width / 5);
                var pos2Y =
                    p2.dy + (height / 2) - math.sin(angle) * (height / 5);

                controller.arrowStart = ArrowData(
                    arrowIndex: controller.arrowStart!.arrowIndex,
                    arrowOffset: Offset(pos1X, pos1Y));

                controller.arrowEnd = ArrowData(
                    arrowIndex: controller.arrowEnd!.arrowIndex,
                    arrowOffset: Offset(pos2X, pos2Y));

                controller.onArrowCreated!(currentIndexData);
                widget.createArrow(true);
              }

              //at this point the arrow is created and the controller is reset
              controller.resetArrowCreating();
            } else {
              //this is the entry point when the arrow creation starts
              controller.arrowStart = currentIndexData;
              controller.onArrowCreated = onTargetFieldSelected;
              controller.creatingArrow = true;
            }
            break;
          case Items.item:
            controller.fieldContents[widget.index] =
                const Icon(Icons.two_wheeler);
            break;
          case Items.delete:
            controller.fieldContents[widget.index] = null;
            break;
          case Items.inspect:
            print(toStringShort());
            break;
          case Items.deleteArrow:
            if (controller.arrowStart != null) {
              controller.arrowEnd = currentIndexData;
              print(
                  "Arrow Rmoved from ${controller.arrowStart?.arrowIndex} to ${controller.arrowEnd?.arrowIndex}");

              widget.removeArrow(true);

              //at this point the arrow is Removed and the controller is reset
              controller.resetArrowCreating();
            } else {
              //this is the entry point when the arrow Remove starts
              controller.arrowStart = currentIndexData;
            }
            break;
        }
        setState(() {});
      },
      child: Container(
        width: 50,
        height: 50,
        color: color,
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Text(
                widget.index.toString(),
                style: const TextStyle(fontSize: 10),
              ),
            )),
            Expanded(
                flex: 6,
                child: Center(child: controller.fieldContents[widget.index])),
          ],
        ),
      ),
    );
  }
}
