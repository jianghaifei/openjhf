import 'package:get/get.dart';

import '../../../../config/rs_locale.dart';
import '../../../function/analytics/analytics_logic.dart';
import '../../../function/mine/mine_setting/mine_setting_logic.dart';
import '../../../generated/l10n.dart';
import 'launch_language_state.dart';

class LaunchLanguageLogic extends GetxController {
  final LaunchLanguageState state = LaunchLanguageState();

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

  Future<void> switchIndex(int index, String source) async {
    if (state.selectedIndex.value != index) {
      state.selectedIndex.value = index;
      await RSLocale().switchLocale(index);

      // 设置页切换语言
      if (source == "MinePage") {
        final AnalyticsLogic analyticsLogic = Get.find<AnalyticsLogic>();
        analyticsLogic.loadAllData();

        final MineSettingLogic mineSettingLogic = Get.find<MineSettingLogic>();
        mineSettingLogic.loadUserConfig();
      }
    }
  }

  void setListTitle() {
    var list = [S.current.rs_languages_auto];
    list.addAll(RSLocale.languagesTitle);
    state.listTitle = list;
  }
}
