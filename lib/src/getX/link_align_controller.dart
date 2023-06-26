import 'package:get/get.dart';

class LinkAlignController extends GetxController {
  bool isAlignVertically = true;
  bool isStraightLine = false;

  void changeIsAlignHorizontally(bool state) {
    isAlignVertically = state;
    update();
  }

  void changeIsStraightLine() {
    isStraightLine = !isStraightLine;
    update();
  }
}
