import 'dart:math';

import 'package:arrows/bottom_bar.dart';
import 'package:arrows/main.dart';
import 'package:flutter/material.dart';

class FieldWidget extends StatefulWidget {
  final int index;
  final GridController gridController;

  const FieldWidget(
      {super.key, required this.gridController, required this.index});

  @override
  State<FieldWidget> createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  Color color = Colors.white;
  List<int> outgoingArrows = [];
  List<int> incomingArrows = [];

  @override
  void initState() {
    color = Color.fromARGB(255, Random().nextInt(80) + 30, 255, 205);
    super.initState();
  }

  void onTargetFieldSelected(int targetField) {
    outgoingArrows.add(targetField);
  }

  @override
  String toStringShort() {
    return "FieldWidget ${widget.index}, outgoingArrows: $outgoingArrows, incomingArrows: $incomingArrows";
  }

  @override
  Widget build(BuildContext context) {
    var controller = widget.gridController;
    return GestureDetector(
      onTap: () {
        if (controller.bottomBarState == null) return;

        switch (controller.bottomBarState!) {
          case Items.arrow:
            if (controller.creatingArrow) {
              controller.arrowEnd = widget.index;

              assert(controller.arrowStart != null);
              assert(controller.onArrowCreated != null);

              // make sure the arrow is not already created
              if (!incomingArrows.contains(controller.arrowStart)) {
                incomingArrows.add(controller.arrowStart!);

                print(
                    "Arrow created from ${controller.arrowStart} to ${controller.arrowEnd}");
                //inform the source field of the arrow creation.
                controller.onArrowCreated!(widget.index);
              }
              //at this point the arrow is created and the controller is reset
              controller.resetArrowCreating();
            } else {
              //this is the entry point when the arrow creation starts
              controller.arrowStart = widget.index;
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
