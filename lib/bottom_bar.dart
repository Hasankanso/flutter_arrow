import 'package:flutter/material.dart';

enum Items { item, arrow, delete, inspect }

class BottomBar extends StatelessWidget {
  final Function(Items pressedItem) onPressed;
  const BottomBar({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Row(
        children: [
          Expanded(
              child: IconButton(
                  onPressed: () {
                    onPressed(Items.item);
                  },
                  icon: const Icon(Icons.two_wheeler))),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    onPressed(Items.arrow);
                  },
                  icon: const Icon(Icons.arrow_forward))),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    onPressed(Items.delete);
                  },
                  icon: const Icon(Icons.close))),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    onPressed(Items.inspect);
                  },
                  icon: const Icon(Icons.troubleshoot))),
        ],
      ),
    );
  }
}
