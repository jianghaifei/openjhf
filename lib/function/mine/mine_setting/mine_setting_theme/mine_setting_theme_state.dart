import 'package:get/get.dart';

import '../../../../config/rs_theme.dart';
import '../../../../generated/l10n.dart';

class MineSettingThemeState {
  var selectedIndex = 0.obs;

  var listData = [
    S.current.rs_languages_auto,
    S.current.rs_theme_light,
    S.current.rs_theme_dark,
  ];

  MineSettingThemeState() {
    ///Initialize variables
    selectedIndex.value = RSTheme().userThemeIndex;
  }
}
