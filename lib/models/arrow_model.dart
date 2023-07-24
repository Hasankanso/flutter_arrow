import 'dart:ui';

class ArrowData {
  //    <-- ArrowData Model class -->
  //index of Arrow
  final int? arrowIndex;
  //Offset of Arrow
  final Offset? arrowOffset;

  ArrowData({this.arrowIndex, this.arrowOffset});
}

class TwoArrowsData {
  //    <-- ArrowData Model class -->
  ArrowData arrowFrom;
  ArrowData arrowTo;
  TwoArrowsData({required this.arrowFrom, required this.arrowTo});
}