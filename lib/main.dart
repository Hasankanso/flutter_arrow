import 'package:flutter/material.dart';

import 'bottom_bar.dart';
import 'field.dart';

import 'models/arrow_model.dart';
import 'painter/arrow_paint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const GridWidget(),
    );
  }
}

class GridWidget extends StatefulWidget {
  const GridWidget({super.key});

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  GridController controller = GridController();

  List<TwoArrowsData> arrowsList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Arrow Challenge"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.leak_remove_sharp, color: Colors.red),
                  onPressed: () {
                    onPressed(Items.deleteArrow);
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: GridView.count(
                    crossAxisCount: 5,
                    children: List.generate(controller.gridSize, (index) {
                      return FieldWidget(
                        index: index,
                        gridController: controller,
                        createArrow: (value) {
                          // On Arrow Created
                          arrowsList.add(TwoArrowsData(
                              arrowFrom: controller.arrowStart!,
                              arrowTo: controller.arrowEnd!));
                          setState(() {});
                        },
                        removeArrow: (bool value) {
                          // On Arrow Removed
                          arrowsList.removeWhere((element) =>
                              element.arrowFrom.arrowIndex ==
                                  controller.arrowStart!.arrowIndex &&
                              element.arrowTo.arrowIndex ==
                                  controller.arrowEnd!.arrowIndex);
                          setState(() {});
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
            floatingActionButton: BottomBar(
              onPressed: onPressed,
            )),
        for (var item in arrowsList)
          CustomPaint(
              painter: ArrowPainter(
                  item.arrowFrom.arrowOffset!, item.arrowTo.arrowOffset!)),
      ],
    );
  }

  void onPressed(Items pressedItem) {
    controller.creatingArrow = false;
    controller.bottomBarState = pressedItem;
  }
}

class GridController {
  int gridSize = 10 * 5;
  Map<int, Widget?> fieldContents = {};
  bool creatingArrow = false;
  Items? bottomBarState;

  //index of source field
  ArrowData? arrowStart;

  //index of the target field
  ArrowData? arrowEnd;

  //user to notify source field of arrow creation completion
  Function(ArrowData targetField)? onArrowCreated;

  void resetArrowCreating() {
    arrowStart = null;
    arrowEnd = null;
    creatingArrow = false;
    onArrowCreated = null;
  }
}
