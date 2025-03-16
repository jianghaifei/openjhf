import 'package:get/get.dart';

import 'login_switch_area_code_state.dart';

class LoginSwitchAreaCodeLogic extends GetxController {
  final LoginSwitchAreaCodeState state = LoginSwitchAreaCodeState();

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

  void performSearch(String query) {
    // 根据搜索关键字过滤数据
    var result = state.originalAreaCodeList
        .where((item) =>
            item.areaCode!.toLowerCase().contains(query.toLowerCase()) ||
            item.area!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    state.displayedAreaCodeList.value = result;
  }
}
