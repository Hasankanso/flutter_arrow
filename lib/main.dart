import 'package:arrows/bottom_bar.dart';
import 'package:arrows/field.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Arrow Challenge"),
        ),
        body: GridView.count(
          crossAxisCount: 5,
          children: List.generate(controller.gridSize, (index) {
            return FieldWidget(
              index: index,
              gridController: controller,
            );
          }),
        ),
        floatingActionButton: BottomBar(
          onPressed: onPressed,
        ));
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
  int? arrowStart;

  //index of the target field
  int? arrowEnd;

  //user to notify source field of arrow creation completion
  Function(int targetField)? onArrowCreated;

  void resetArrowCreating() {
    arrowStart = null;
    arrowEnd = null;
    creatingArrow = false;
    onArrowCreated = null;
  }
}
