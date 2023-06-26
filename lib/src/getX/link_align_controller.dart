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

// isAlignVertically가 true면 y/2, false면 x/2로 중간지점 설정
// 에디터 우측하단의 정렬 버튼 누르면 여기 있는 메서드 호출해서 상태 변경.
// 재정렬하면서 중간지점 위치도 다시 업데이트 해줘야함.