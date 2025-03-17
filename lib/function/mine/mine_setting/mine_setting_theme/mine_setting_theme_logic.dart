import 'package:flutter_report_project/config/rs_theme.dart';
import 'package:get/get.dart';

import 'mine_setting_theme_state.dart';

class MineSettingThemeLogic extends GetxController {
  final MineSettingThemeState state = MineSettingThemeState();

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

  Future<void> switchIndex(int index) async {
    await RSTheme().switchDarkMode(index);

    state.selectedIndex.value = index;
  }
}
