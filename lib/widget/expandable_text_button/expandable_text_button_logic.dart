import 'package:get/get.dart';

import 'expandable_text_button_state.dart';

class ExpandableTextButtonLogic extends GetxController {
  final ExpandableTextButtonState state = ExpandableTextButtonState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  toggle() {
    state.isExpanded.value = !state.isExpanded.value;
    if (state.isExpanded.value) {
      state.animationController?.forward(); // 向上箭头动画
    } else {
      state.animationController?.reverse(); // 向下箭头动画
    }
  }

  close() {
    state.isExpanded.value = false;
    state.animationController?.reverse(); // 恢复箭头动画
  }
}
