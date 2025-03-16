import 'package:flutter_report_project/config/rs_locale.dart';
import 'package:get/get.dart';

class MineSettingLanguageState {
  var selectedIndex = 0.obs;

  MineSettingLanguageState() {
    ///Initialize variables

    selectedIndex.value = RSLocale().localeIndex;
  }
}
